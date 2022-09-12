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

> Updated for Swift 5.7 (Xcode 14 beta 5)
{: .prompt-info }

This article goes through the steps of creating a simple command-line tool and solve for common feature requirements with helpful open-source packages.  
The tool will provide some functionality to print out information about files and directories on the file system.  

Let's first create a Swift package.

```terminal
$ mkdir MyApp
$ cd MyApp/
$ swift package init --type executable
$ swift run
Building for debugging...
Build complete! (1.18s)
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
Building for debugging...
[5/5] Linking MyApp
Build complete! (6.06s)
Package.resolved
Package.swift
README.md
```

That was really easy and already very exciting. 😎

Swift Argument Parser
---------------------

Something that nearly every command-line app has, are arguments and option parameters. Rather than implementing them from scratch, I'm going to use Apple's open-source package. Namely Apple's [Swift Argument Parser](https://github.com/apple/swift-argument-parser) (`ArgumentParser`).

To install this package, add `.package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),`[^fn-latest-sap] to your `Package.swift`'s `dependencies` in the same way as `Files` above.

> An alternative would be [`SwiftCLI`](https://github.com/jakeheis/SwiftCLI.git), which has been around longer, and provides nearly the same functionality.
{: .prompt-info }

`ArgumentParser` uses property wrappers to declare its parsable parameters.  

- `@Argument` for positional command-line argument
- `@Option` for optional arguments (with `--` or `-` prefixes)
- `@Flag` for boolean command-line flags (also with `--` or `-`)

Furthermore, a `--help` (`-h`) documentation for your command-line application is automatically generated.

For our finished example, it will look like this:

```terminal
$ swift run MyApp -h
OVERVIEW: A neat little tool to list files and directories

USAGE: my-app [<path>] [--directories] [--include-hidden]

ARGUMENTS:
  <path>                  Path of the directory to be listed (default: .)

OPTIONS:
  -d, --directories       Include directories
  -i, --include-hidden    Include hidden files/directories
  --version               Show the version.
  -h, --help              Show help information.
```

> Use `swift run AppName` to be able to use your arguments and parameters when debugging.
{: .prompt-tip }

If you want to use a different argument label than the variable name, you can specify this via the property wrappers `name` property in various ways. For example, a `directories` flag to toggle whether to include directories in our list, could be defined with the following `name` options:

```swift
@Flag(name: [.short, .long, .customLong("dir")])
var directories = false
```

This will enable you to use the flag in one of the following ways.

```terminal
$ swift run MyApp --directories
$ swift run MyApp --dir
$ swift run MyApp -d
```

Again, `swift run MyApp --help` will show these options automatically:

```terminal
OPTIONS:
  -d, --directories, --dir
```

There's also `@OptionGroup` which let's you compile multiple parameters into a struct (conforming to `ParsableArguments`) for reusability.

Sample from the [documentation](https://apple.github.io/swift-argument-parser/documentation/argumentparser/optiongroup): 
```swift
struct GlobalOptions: ParsableArguments {
    @Flag(name: .shortAndLong)
    var verbose: Bool

    @Argument var values: [Int]
}

struct Options: ParsableArguments {
    @Option var name: String
    @OptionGroup var globals: GlobalOptions
}
```

> `ArgumentParser`'s `ParsableCommand`s have a `run()` method that acts as the entry point for your command instead of a static `main()`
{: .prompt-info }

```terminal
$ swift run MyApp --directories
Building for debugging...
Build complete! (0.13s)
-- MyApp --
[Sources]
[Tests]
Package.resolved
Package.swift
README.md

$ swift run MyApp -id
Building for debugging...
Build complete! (0.12s)
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
```

### Subcommands

For more complex applications, the ArgumentParser package lets you define [Subcommands](https://apple.github.io/swift-argument-parser/documentation/argumentparser/commandsandsubcommands) as part of the applications configuration.  

E.g. having an additional parameter-like keyword after the application's name, allowing you to group utilities within your application, like:

```terminal
$ MyApp subcommand --parameter
```

This is controlled via a [`CommandConfiguration`](https://apple.github.io/swift-argument-parser/documentation/argumentparser/commandconfiguration) (also provided by `ArgumentParser`) object defined as a static variable on your base `ParsableCommand`.

```swift
@main
struct MyApp: ParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "My awesome CLI tool.",
        subcommands: [FirstSubcommand.self, SecondSubcommand.self],
        defaultSubcommand: FirstSubcommand.self
    )
}
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
Especially [`AssertExecuteCommand(command:, expected:)`](https://github.com/apple/swift-argument-parser/blob/6f30db08e60f35c1c89026783fe755129866ba5e/Sources/ArgumentParserTestHelpers/TestHelpers.swift#L209-L213), which makes it really easy to execute a command and check for its expected output.

```swift
func test_output() throws {
    try AssertExecuteCommand(
        command: "MyApp",
        expected: "Hello, world!"
    )
}
```

Distribution
------------



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

- [Apple Documentation](https://github.com/apple/swift-package-manager/tree/main/Documentation)
- [Creating a Packge](https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md#creating-a-package) (CLI tool, etc.)
- [https://github.com/apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
- [https://github.com/JohnSundell/Files](https://github.com/JohnSundell/Files)

---
## Footnotes

[^fn-latest-sap]: Latest at time of writing. See [Releases](https://github.com/apple/swift-argument-parser/releases)
