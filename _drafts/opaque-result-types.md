---
layout: post
title: Opaque Result Types
category: [Summaries, SwiftUI]
tags: swift
date: 2021-10-02 17:51 +0900
---

[SE-0244](https://github.com/apple/swift-evolution/blob/master/proposals/0244-opaque-result-types.md) enables generic protocols to be used as return types.  
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

Without the use of `some` as above the compiler would throw a much disliked error that's often seen when working with generic types:  
`Protocol 'SomeProtocol' can only be used as a generic constraint because it has Self or associated type requirements`

## Bigger picture

For **SwiftUI** this is what enables the *Result Builders* behind `VStack`, `Group`, or any `body` property of a SwiftUI `View` to return different variants of the same protocol.  
`some View` as a return type allows the use of any type that conforms to the generic protocol `View`.  
May it be `TupleView<(Text, Text)>` or `TupleView<(Text, Text, Text)>`.

## Future Plans

Just having `some` for result types doesn't solve the `Self or associated type requirements` problem completely.  

For example, if I try to create an array consisting of types conforming to a generic protocol, I'll run into our old friend again:

```swift
let array = [A(), B()]
// Heterogeneous collection literal could only be inferred to '[Any]'; add explicit type annotation if this is intentional

let array: [SomeProtocol] = [A(), B()]
// Protocol 'SomeProtocol' can only be used as a generic constraint because it has Self or associated type requirements

let array: [some SomeProtocol] = [A(), B()]
// 'some' types are only implemented for the declared type of properties and subscripts and the return type of functions
```

It seems that this will be solved by the inclusion of [SE-0309: Unlock existentials for all protocols](https://github.com/apple/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md)[^fn-se-0309-review][^fn-se-0309-accepted] which will [most likely be included in Swift 5.6](https://forums.swift.org/t/is-0309-in-the-beta-of-swift-5-5-xcode-13/49402/3).

This is also touched at in [this great article by Tim Ekl](https://www.timekl.com/blog/2021/04/26/swift-generics-2-existentials-boogaloo/#quiet-on-the-set-or-array) by [@timothyekl](https://twitter.com/timothyekl) explaining the nature of the proposal.


--- 

[^fn-se-0309-review]: [SE-0309 Review Thread](https://forums.swift.org/t/se-0309-unlock-existential-types-for-all-protocols/47515)
[^fn-se-0309-accepted]: [SE-0309 Accepted Thread](https://forums.swift.org/t/accepted-se-0309-unlock-existentials-for-all-protocols/47902)
