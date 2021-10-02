---
layout: post
title: SwiftUI Tabbed Page View - Part 2
category: Articles
date: 2021-08-29 16:43 +0900
tags: swift swiftui ios
---

[Part 1]({% post_url 2021-08-29-swiftui-tabbed-page-view %})

As promised, here's the second post about creating a tabbed page view, where I'm trying to extract the functionality into more *swiftUIy* reusable components.

Let's start with the *ideal* API our component might be able to expose.

A regular `TabView` call site looks like this:

```swift
TabView {
    View1()
        .tabItem {
            Label("Menu", systemImage: "list.dash")
        }

    View2()
        .tabItem {
            Label("Order", systemImage: "square.and.pencil")
        }
}
```
Ideally something similar 
```swift
  TabbedPageView {
    View1()
    .tabItem {
        Label("View 1")
    }
  }
```

getting a weird error

`AttributeGraph precondition failure: attribute being read has no value: 357912.`
