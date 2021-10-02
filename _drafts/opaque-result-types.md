---
layout: post
title: Opaque Result Types
category: [Summaries, SwiftUI]
tags: swift
date: 2021-10-02 17:51 +0900
---

[SE-0244](https://github.com/apple/swift-evolution/blob/master/proposals/0244-opaque-result-types.md)

Enables generic protocols to be used as return types.  
(i.e. ones that have associated types or references to `Self`)

This means that given a protocol with associated type, such as:

```swift
protocol SomeProtocol {
    associatedtype OtherType

    func someFunction() -> OtherType
}
```

... and implementations of `SomeProtocol`, that use different types for `OtherType`

```swift
struct A: SomeProtocol {
    func someFunction() -> Int { 1_234 }
}

struct B: SomeProtocol {
    func someFunction() -> String { "ABCD" }
}
```

... we can now use these implementations interchangably as returned types for `OtherType` as long as we mark the return type in the function signature with the `some` keyword:

```swift
func foo() -> some SomeProtocol {
    A()
}

func bar() -> some SomeProtocol {
    B()
}

foo().someFunction() // 1234
bar().someFunction() // ABCD
```

Without the use of the `some` as above the compiler would throw an error:  
`Protocol 'SomeProtocol' can only be used as a generic constraint because it has Self or associated type requirements`

For SwiftUI this is what enables the **Result Builders** behind `VStack`, `Group`, etc. where 
