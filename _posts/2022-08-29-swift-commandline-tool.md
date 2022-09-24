---
title: Swift Command-Line Tool
category:
- Articles
- Tools
tags:
- shell
- tools
- swift
date: 2022-08-25 12:46 +0900
---

Intro
-----

> Updated for Swift 5.7 (Xcode 14)
{: .prompt-info }

This article walks through the steps of creating a simple command-line tool and solve common feature requirements with helpful open-source packages.  
The finished tool will print out information about files and directories on the file system.  

Setup
-----

Let's first create a Swift package:

```terminal
$ mkdir MyApp && cd MyApp
$ swift package init --type executable
$ swift run
Building for debugging...
[3/3] Linking MyApp
Build complete! (0.82s)
Hello, World!
```

I'm going to use John Sundell's [`Files`](https://github.com/JohnSundell/Files) package for filesystem interactions, adding it as a dependency in `Package.swift`.

```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: ["Files"]),
        .testTarget(
            name: "MyAppTests",
            dependencies: ["MyApp"]),
    ]
)
```
{: file='Package.swift' }

`MyApp.swift` is the templates entry-point and for now, we'll replace its `Hello, world!` content with some simple logic to print out the current directory's listing.

```swift
import Files

@main
public struct MyApp {

    public static func main() throws {
        try MyApp().printFiles()
    }

    func printFiles() throws {
        for file in try Folder(path: ".").files {
            print(file.name)
        }
    }
}
```
{: file='Sources/MyApp/MyApp.swift'}

> Notice that the source files for our executable target reside in `Sources/TARGET_NAME/*`.  
> If you'd like to have them somewhere else, you need to explicitly specify the `path` parameter for your
> [`executableTarget`](https://developer.apple.com/documentation/packagedescription/target/executabletarget(name:dependencies:path:exclude:sources:resources:publicheaderspath:csettings:cxxsettings:swiftsettings:linkersettings:plugins:)?changes=_6) in `Package.swift`
{: .prompt-info }

Let's take it for a spin:

```terminal
$ swift run
Package.resolved
Package.swift
README.md
```

That was really easy and already very exciting. 😎

Swift Argument Parser
---------------------

Something that arguably every command-line app needs, are arguments. Rather than implementing them from scratch, I'm going to use Apple's open-source package [Swift Argument Parser](https://github.com/apple/swift-argument-parser) (I'm referring to this package as `ArgumentParser` below).

> An alternative would be [`SwiftCLI`](https://github.com/jakeheis/SwiftCLI.git), which has been around longer, and provides nearly the same functionality.
{: .prompt-info }

> If you'd rather roll your own argument parsing solution, you can do so by manually reading them from `CommandLine.arguments.dropFirst()`

We add `.package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),`[^fn-latest-sap] to `Package.swift`'s `dependencies` in the same way as for `Files` above, but need to specify the exact product we want to add as a dependency for our `executableTarget`, because the product `ArgumentParser` has a different name than the package `swift-argument-parser` and can't be automatically inferred by SPM. 

```swift
// ...
.executableTarget(
    name: "MyApp",
    dependencies: [
        "Files",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
    ]),
// ...
```
{: file='Package.swift' }


We import the module and conform our struct to `ParsableCommand`.

```swift
import ArgumentParser
import Files

@main
struct MyApp: ParsableCommand {

    mutating func run() throws {
        try printFiles()
    }

    func printFiles() throws {
        for file in try Folder(path: ".").files {
            print(file.name)
        }
    }
}
```
{: file='Sources/MyApp/MyApp.swift'}

> `ArgumentParser`'s `ParsableCommand`s require a `run()` method that acts as the entry point for your command instead of the static `main()`
{: .prompt-info }

`ArgumentParser` uses property wrappers to declare its parsable parameters.  

- `@Argument` for positional command-line argument
- `@Option` for named parameters (with `--` or `-` prefixes)
- `@Flag` for boolean command-line flags (also with `--` or `-`)

Furthermore, a `--help` (`-h`) documentation for your command-line application is automatically generated.

For our finished example, it will look like this:

```terminal
$ swift run MyApp -h
OVERVIEW: A neat little tool to list files and directories

USAGE: my-app list [<path>] [--directories] [--include-hidden] [--filter <filter>]

ARGUMENTS:
  <path>                  Path of the directory to be listed (default: .)

OPTIONS:
  -d, --directories       Include directories
  -i, --include-hidden    Include hidden files/directories
  -f, --filter <filter>   Filter the list of files and directories
  --version               Show the version.
  -h, --help              Show help information.
```

> Use `swift run AppName` from a terminal in the root directory of your Swift package to quickly debug the arguments and parameters of your application.
{: .prompt-tip }

We want to pass a filesystem path to our tool, so that we can list files in other directories, too. This argument should have the current directory as a default: 

```swift
@Argument(help: "Path of the directory to be listed")
var path: String = "."
```

We'll also update our code to use this new variable and print out the name of the current folder.

```swift
mutating func run() throws {
    print("-- \(try Folder(path: path).name) --")
    try printFiles()
}

func printFiles() throws {
    for file in try Folder(path: path).files {
        print(file.name)
    }
}
```

```terminal
$ swift run MyApp Sources/MyApp
-- MyApp --
MyApp.swift
```

We'll also add a parameter to display directories in addition to files in our list.  

```swift
@Flag(help: "Include directories")
var includeDirectories: Bool = false
```

If you want to use a different parameter label than the variable name, you can specify this via the property wrapper's `name` property in various ways. For example, our `--include-directories` flag (`ArgumentParser` will turn it into kebab-case by default) could be set like this:

```swift
@Flag(name: [.short, .long, .customLong("dir")])
var includeDirectories = false
```

In order to make the following commands available to the user: 

```terminal
$ swift run MyApp --include-directories
$ swift run MyApp --dir
$ swift run MyApp -d
```

Again, `swift run MyApp --help` will show these options automatically:

```terminal
OPTIONS:
  -d, --include-directories, --dir
```

We'll add one more `@Flag` to toggle whether hidden files and directories should be listed.

```swift
@Flag(name: [.long, .short], help: "Include hidden files/directories")
var includeHidden: Bool = false
```

Let's also include the third type of command-line parameter, by creating a option to filter the list:

```swift
@Option(name: .shortAndLong, help: "Filter the list of files and directories")
var filter: String?
```


```swift
@main
struct MyApp: ParsableCommand {

    @Argument(help: "Path of the directory to be listed")
    var path: String = "."

    @Flag(name: [.customLong("directories"), .customShort("d")], help: "Include directories")
    var includeDirectories: Bool = false

    @Flag(name: .shortAndLong, help: "Include hidden files/directories")
    var includeHidden: Bool = false

    @Option(name: .shortAndLong, help: "Filter the list of files and directories")
    var filter: String?

    mutating func run() throws {
        print("-- \(try Folder(path: path).name) --")
        if includeDirectories {
            try printDirectories()
        }
        try printFiles()
    }
}

private extension MyApp {

    private func printFiles() throws {
        var files = try Folder(path: path).files

        if includeHidden {
            files = files.includingHidden
        }

        for file in files {
            if let filter, !file.name.contains(filter) {
                continue
            }
            print(file.name)
        }
    }

    private func printDirectories() throws {
        var folders = try Folder(path: path).subfolders

        if includeHidden {
            folders = folders.includingHidden
        }

        for folder in folders {
            if let filter, !folder.name.contains(filter) {
                continue
            }
            print("[\(folder.name)]")
        }
    }
}
```
We have some unnecessary duplication, but the code serves our purpose and the results are looking good:

```terminal
$ swift run MyApp -di
-- MyApp --
[.build]
[.git]
[.swiftpm]
[Sources]
[Tests]
.gitignore
Package.resolved
Package.swift
README.md

$ swift run MyApp -di -f git
-- MyApp --
[.git]
.gitignore
```

There's also [`@OptionGroup`](https://apple.github.io/swift-argument-parser/documentation/argumentparser/optiongroup) which is used to compile multiple parameters into a struct (conforming to `ParsableArguments`) for reusability, e.g. across multiple `Subcommand`s.  
We look at subcommands in the next section and make use of `@OptionGroup` there.

### Subcommands & Configuration

For more complex applications, the ArgumentParser package lets you define [Subcommands](https://apple.github.io/swift-argument-parser/documentation/argumentparser/commandsandsubcommands) as part of the applications configuration.  

E.g. having an additional parameter-like keyword after the application's name, allowing you to group utilities within your application, like:

```terminal
$ MyApp subcommand --parameter
```

This is controlled via a [`CommandConfiguration`](https://apple.github.io/swift-argument-parser/documentation/argumentparser/commandconfiguration) object defined as a static property on your base `ParsableCommand`.  

Just for illustration, I'll add a second command `name-length` to our existing tool, which will simply print out the character count of the names of files and directories in our list instead of the actual names.

```swift
@main
struct MyApp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A neat little tool to list files and directories",
        version: "1.2.3",
        subcommands: [List.self, NameLength.self],
        defaultSubcommand: List.self
    )
}
```

With this, we just have to move our previous implementation to a newly created `List` type and can also utilized the aforementioned `@OptionGroup` to reuse all our arguments for the second command in `NameLength`.

```swift
struct GlobalOptions: ParsableArguments {
    @Argument(help: "Path of the directory to be listed")
    var path: String = "."

    @Flag(name: [.customLong("directories"), .customShort("d")], help: "Include directories")
    var includeDirectories: Bool = false

    @Flag(name: .shortAndLong, help: "Include hidden files/directories")
    var includeHidden: Bool = false

    @Option(name: .shortAndLong, help: "Filter the list of files and directories")
    var filter: String?
}

extension MyApp {
    struct List: ParsableCommand {
        @OptionGroup var args: GlobalOptions

        // ...
    }

    struct NameLength: ParsableCommand {
        @OptionGroup var args: GlobalOptions
        
        // ...
    }
```
I've shortened the sample code here a bit, because the implementation of `NameLength` is almost identical to `List`.

```terminal
$ swift run MyApp name-length
Building for debugging...
[3/3] Linking MyApp
Build complete! (0.73s)
-- MyApp --
16
13
9
```

### Parsing Arguments into more complex types

Date 
https://forums.swift.org/t/support-for-date/34797

```swift
func parseDate(_ formatter: DateFormatter) -> (String) throws -> Date {
    { arg in
        guard let date = formatter.date(from: arg) else {
            throw ValidationError("Invalid date")
        }
        return date
    }
}

let shortFormatter = DateFormatter()
shortFormatter.dateStyle = .short

// .....later
@Argument(transform: parseDate(shortFormatter))
var date: Date
```

Tests
-----

The package template already created a test target `MyAppTests` in `Package.swift` for us. It contains an example of a functional test case for the template's `Hello, world!` output.

> In Xcode 14 Swift 5.7 the package struct and test setup has changed slighly.  
> However the new test case seems more like a unit test than a functional test, to be honest...
{: .prompt-info }

I can recommend having a look at the `TestHelpers` of the [`ArgumentParser` Repository](https://github.com/apple/swift-argument-parser/blob/6f30db08e60f35c1c89026783fe755129866ba5e/Sources/ArgumentParserTestHelpers/TestHelpers.swift).
Especially [`AssertExecuteCommand(command:, expected:)`](https://github.com/apple/swift-argument-parser/blob/6f30db08e60f35c1c89026783fe755129866ba5e/Sources/ArgumentParserTestHelpers/TestHelpers.swift#L209-L213), which simplifies creating functional tests that execute a command and check for its expected output.

```swift
func test_output() throws {
    try AssertExecuteCommand(
        command: "MyApp",
        expected: "Hello, world!"
    )
}
```

## Excursion: Refactoring

> TODO
{: .prompt-warning }

Now that I have some tests that are ensuring our app works as it should, I can improve some of the code 

Distribution
------------

> TODO
{: .prompt-warning }

---

## Appendix

### Swift 5.5 and below: Migrate from `main.swift` to `@main`

In the generated template, the swift compiler uses our source file named `main.swift` as an entry point and simply runs the top-level code it finds within.

If you want to write more *structured* code and have a `struct` represent the entry point, an easy way to do so is as follows: 

1. Mark the `struct` with `@main` to tell the compiler that this is the new entry point for our application
2. Rename the file to something other than `main.swift`

```swift
@main
struct MyApp {

    static func main() throws {
        print("Hello")
    }
}
```
{: file='Sources/MyApp/MyApp.swift'}

### Sample Implementation using `main.swift` without `@main`

see [https://developer.apple.com/swift/blog/?id=7](https://developer.apple.com/swift/blog/?id=7)

```swift
import Darwin

struct CommandLineApp {
    mutating func run() throws {
        print("Hello")
    }

    static func main() {
        var cmd = Self()
        do {
            try cmd.run()
        } catch {
            print(error)
            Darwin.exit(0)
        }
    }
}
CommandLineApp.main()
```
{: file='Sources/MyApp/main.swift'}

References
----------

- [Apple Documentation (SPM)](https://github.com/apple/swift-package-manager/tree/main/Documentation)
- [Creating a Package](https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md#creating-a-package) (CLI tool, etc.)
- [https://github.com/apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
- [https://github.com/JohnSundell/Files](https://github.com/JohnSundell/Files)

---
## Footnotes

[^fn-latest-sap]: Latest at time of writing. See [Releases](https://github.com/apple/swift-argument-parser/releases)
