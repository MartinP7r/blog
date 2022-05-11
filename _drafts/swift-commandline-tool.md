---
title: Swift Commandline Tool
# author:
#   name: Martin
#   link: https://twitter.com/MartinP7r 
date: 2022-01-30 12:46 +0900
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
And take it for a spin:

{: file='Sources/MyApp/main.swift'}

```terminal
$ swift run
[3/3] Build complete!
Package.resolved
Package.swift
README.md
```

That was almost too easy and already very exciting.  

Now, if we want to write something more complex than our simple script above, we will need some more structure in our code than just a simple sequential file.  

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

If you want to use a different argument label than the variable name, you can specify this via the property wrappers `name` property. For example, having a `date` argument that can also be shortened to `-d`, but


Tests
-----

The package template already created a test target `MyAppTests` in `Package.swift` for us. It contains an example of a functional test case for the template's `Hello, world!` output with.

For 


I can recommend having a look at the `TestHelpers` of the [`ArgumentParser` Repository](https://github.com/apple/swift-argument-parser/blob/6f30db08e60f35c1c89026783fe755129866ba5e/Sources/ArgumentParserTestHelpers/TestHelpers.swift).


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

Nate 
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
