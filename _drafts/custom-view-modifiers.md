---
layout: post
title: Custom View Modifiers
date: 2021-10-16 21:40 +0900
categories: [Summaries SwiftUI]
tags: [swift swiftui]
---

Types that conform to the `ViewModifier` protocol take a `View`, modify it in some way, and return the resulting view.

In their implementation view modifiers are somewhat similar to views. 
However, instead of a property, their `body` is a function that takes an [opaque]({% post_url 2021-10-03-opaque-result-types %}) `View` and returns a modified `View`.

Typical examples change the style or shape of the view, such as `.font()`, `.padding()`, `.clipShape()`.

It's also possible to create your own custom modifiers by conforming a struct to the `ViewModifier` protocol.

[Example]

A extension on `View` will make the modifier more convenient to use 

[Example with call site]

<!-- TODO: wait for answer on https://developer.apple.com/forums/thread/132627?login=true&page=1#691644022

## Constrained Modifiers

If you want to use modifiers that are contrained to a specific type or want to add a custom modifier 
for only a specific `View` type, let's say `Text`, for simple cases you could just add an extension 
on that type without the need to create a new `ViewModifier`:

```swift
extension Text {
    func hulk() -> some View {
        self.font(.largeTitle)
            .bold()
            .foregroundColor(.green)
    }
}

// call site
Text("Smash!!")
    .hulk()
```

However, if your use case is a little more involved, for example when keeping state or a binding 

[TBC]

![image](/../assets/img/view_modifier_hulksmash.gif)

-->

## Compositional Modifiers

Nothing keeps you from taking the original view and wrapping it in another container view.

```swift
struct VStacker: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
            Text("And some other View")
        }
    }
}

Text("Here's a view")
    .modifier(VStacker())
```

![image](/../assets/img/view_modifier_wrapped.png)


Taking this further, if we use a `@ViewBuilder` Result Builder <!-- TODO: [Result Builder](LINK_NEEDED) -->, we can pass in an arbitrary `View` and use it with our modified view.

```swift
struct VStacker<SecondView: View>: ViewModifier {
    @ViewBuilder var secondView: () -> SecondView

    func body(content: Content) -> some View {
        VStack {
            content
            secondView()
        }
    }
}

extension View {
    func vStack<S: View>(@ViewBuilder view: @escaping () -> S) -> some View {
        self.modifier(VStacker(secondView: view))
    }
}

Text("Hello, world!")
    .vStack { Image(systemName: "hands.sparkles") }
    .vStack { Image(systemName: "globe") }
```

![image](/../assets/img/view_modifier_viewbuilder_stack.png)
