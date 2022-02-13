---
layout: post
title: 'Handling "unlikely to fail" failing code paths'
date: 2022-02-13 13:43 +0900
category:
- Summaries
- iOS
tags:
- ios
- swift
---

There's situations where a failing code path is there, but under normal circumstances will not happen and therefore should not be handled as if it could.  
For example, retrieving the url of a file in the app's bundle is something that could potentially fail (if the file is not in the bundle), but should never be an issue in code (because you would have made sure that the file is actually in the bundle...).  

```swift
class OtherClass {
    init(jsonURL: URL) { /* ... */ }
}

class MyClass {
    let otherClass: OtherClass

    init() {
        let url = Bundle.main.url(forResource: "som_file", withExtension: "json") 

        // This will not work because url is optional
        otherClass = OtherClass(jsonURL: url)
    }
}
```

`someFileUrl` in this case is optional, but needn't be.  
Of course there's a chance you actually forgot to include `some_file` in your bundle. But that's a compile time problem.  
From the point your app is created, this method would then 100% of the time fail to produce a valid `URL`.  


In these cases, we want to continue the code as clean as possible, ideally *"failing"* early with a `guard` statement.

```swift
init() {
    guard let url = Bundle.main.url(forResource: "som_file", withExtension: "json") else {
        // 
    }

    otherClass = OtherClass(jsonURL: url)
}
```
However, the only permitted return value from an initializer is `nil` and that wouldn't be a nice API to use for the consumer of `MyClass`.

There's ways of handling code paths like these without any additional handling in code.  
They come with some risks to take into account.


## fatalError()

> Unconditionally prints a given message and stops execution.

Stops execution (Crashes the app) when called. Period.  
But if there's nothing coming after it, the compiler doesn't need to worry about it.  

```swift
init() {
    guard let url = Bundle.main.url(forResource: "som_file", withExtension: "json") else {
        fatalError("Missing json file.") 
    }

    otherClass = OtherClass(jsonURL: url)
}
```

More helpful if you want to actually know what went wrong in debugging:

## preconditionFailure()

> Use this function to stop the program when control flow can only reach the call if your API was improperly used. This function’s effects vary depending on the build flag used:
> * In playgrounds and -Onone builds (the default for Xcode’s Debug configuration), stops program execution in a debuggable state after printing message.
> * In -O builds (the default for Xcode’s Release configuration), stops program execution.
> * In -Ounchecked builds, the optimizer may assume that this function is never called. Failure to satisfy that assumption is a serious programming error.

Always evaluated => guarantees that execution will stop.  

```swift
init() {
    guard let url = Bundle.main.url(forResource: "som_file", withExtension: "json") else {
        fatalError("Missing json file.") 
    }

    otherClass = OtherClass(jsonURL: url)
}
```

In a similar situation, you won't actually care if the file is not there or don't want to crash the app.  
For example if the file belongs to the bundle of an external dependency that you rely on.

## assertionFailure()

> Use this function to stop the program, without impacting the performance of shipping code, when control flow is not expected to reach the call—for example, in the default case of a switch where you have knowledge that one of the other cases must be satisfied. To protect code from invalid usage in Release builds, see preconditionFailure(_:file:line:).
> * In playgrounds and -Onone builds (the default for Xcode’s Debug configuration), stop program execution in a debuggable state after printing message.
> * **In -O builds, has no effect.**
> * In -Ounchecked builds, the optimizer may assume that this function is never called. Failure to satisfy that assumption is a serious programming error.

This causes a `fatalError` in debug builds and is *ignored in release builds*.
**So this can't be used for guard statements since it does not break the control flow.**  
This allows for graceful failing. However you need to handle the exit yourself in code. There's no way around returning `nil` from the initializer above for example.
So, it's useful if you want to have tests fail but it's no something that should crash the app if it ever happens.  

---
References: 
* https://www.swiftbysundell.com/articles/picking-the-right-way-of-failing-in-swift/
* https://agostini.tech/2017/10/01/assert-precondition-and-fatal-error-in-swift/
