---
title: Swift Commandline Tool
date: 2022-08-25 12:46 +0900
---
SwiftPM Command Line Tool
=========================

Let's first create a package and print the directory list for the current directory.

```terminal
$ mkdir MyApp
$ cd MyApp/
$ swift package init --type executable
$ swift build
$ swift run
[0/0] Build complete!
Hello, world! 
```

I'm going to use John Sundell's `Files` package for the filesystem interaction, adding it as a dependency in the generated `Package.swift`.

```swift
// swift-tools-version:5.5
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

`main.swift` is the templates entry-point and we'll just replace its `Hello, world!` content with some simple logic to print out the current directory's listing.

```swift
import Files

for file in try Folder(path: ".").files {
    print(file.name)
}
```
{: file='Sources/MyApp/main.swift'}

And take it for a spin:

```terminal
$ swift run
[3/3] Build complete!
Package.resolved
Package.swift
README.md
```

That was really easy and already very exciting.  

Now, if we want to write something more complex than our simple script above, we will need something more structured than just a simple sequential file.  

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

Alternatively, if you want to keep `main.swift`, you have to implement things yourself.[^fn-main-swift]

Swift Argument Parser
---------------------

`ArgumentParser` uses property wrappers to declare its parsable parameters.  

Popular ones are 
- `@Argument` for positional command-line arguments
- `@Option` for optional arguments (with `--` or `-` prefixes)
- `@Flag` for boolean command-line flags (also with `--` or `-`)

Furthermore this are automatically included in the `--help` documentation of your command-line application.

Then there's also `@OptionGroup` which let's you group multiple such parameters inside a struct (conforming to `ParsableArguments`) for reusability.

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

If you want to use a different argument label than the variable name, you can specify this via the property wrappers `name` property. 

Given a "tomorrow" flag defined with the following name options:
```swift
@Flag(name: [.long, .short, .customLong("tmr")])
var tomorrow = false
```
This will enable you use the parameter in one of the following ways.
```terminal
$ swift run MyApp --tomorrow
$ swift run MyApp --tmr
$ swift run MyApp -t
```

`swift run MyApp --help` will show the options automatically:
```terminal
OPTIONS:
  -t, --tomorrow, --tmr
```

### Subcommands

For more complex applications, the ArgumentParser package lets you define [Subcommands](https://apple.github.io/swift-argument-parser/documentation/argumentparser/commandsandsubcommands) as part of the applications configuration.  

E.g. having an additional parameter-like keyword after the application's name, allowing you to group utilities within your application, like:

```terminal
$ MyApp sub-command parameter
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

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    enum Error: Swift.Error {
        case invalidDate
    }
}
```

Tests
-----

The package template already created a test target `MyAppTests` in `Package.swift` for us. It contains an example of a functional test case for the template's `Hello, world!` output.

> info
> In Xcode 14 Swift 5.7 the package struct and test setup are slighly different.  
> However the new test case seems more like a unit test than a functional test, to be honest...

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

---

# Appendix

Sample Implementation using `main.swift` without `@main`[^fn-main-swift]

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


## Parsing Arguments

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

References
----------

- [Apple Documentation](https://github.com/apple/swift-package-manager/tree/main/Documentation)
- [Creating a Packge](https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md#creating-a-package) (CLI tool, etc.)

- https://github.com/apple/swift-argument-parser
- https://github.com/JohnSundell/Files

[^fn-main-swift]: https://developer.apple.com/swift/blog/?id=7
