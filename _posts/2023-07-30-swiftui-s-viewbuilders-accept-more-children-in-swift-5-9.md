---
layout: post
title: SwiftUI's ViewBuilders accept more children in Swift 5.9
category:
tags:
date: 2023-07-30 13:12 +0900
---
Thanks to [Parameter Packs](https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md) and other additons to Swift in version 5.9, variadic generics are now possible.  
Parameter packs permit the declaration of generic types and functions that can accept an arbitrary number of generic arguments. 

It's explained in some detail in the WWDC23 session [Generalize APIs with parameter packs](https://developer.apple.com/wwdc23/10168).

Prior to this change, developers needed to define multiple overloaded functions or types to handle different numbers of generic parameters. 

For example, in SwiftUI it's not necessary anymore to add sub-groupings with [`Group`](https://developer.apple.com/documentation/swiftui/group) for the sole reason of having more than 10 views inside a parent viewbuilder:

![](https://imgur.com/l5bKM7y.png)

This change is not restricted to iOS 17. As long as you are using Swift 5.9 or newer, it will be available in earlier versions as well.
