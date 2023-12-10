---
layout: post
title: Newsletter Summaries Week 47 (2023)
category: Newsletter
tags:
- swift
- swiftui
date: 2023-11-30 09:04 +0900
---
## SwiftData operations on background

Source: [SwiftData Background Tasks](https://useyourloaf.com/blog/swiftdata-background-tasks/)

Use a custom `ModelActor` for the model to run operations on a background context.

```swift
modelExecutor = DefaultSerialModelExecutor(modelContext: context)
```

When passing objects between actors, we should use persistent identifiers, so there's a convenience subscript on `ModelActor`

```swift
func visit(identifiers: [Country.ID]) {
  for identifier in identifiers {
    if let country = self[identifier, as: Country.self] {
      country.visited = true
    }
  }
}
```

## Sized to fit bottom sheet in SwiftUI

Source: [Sized-to-fit SwiftUI bottom sheet | Matthew's Dev Blog](https://matthewcodes.uk/articles/swiftui-size-to-fit-bottom-sheet/)

This is really nice and I'm definitely going to use it in one of my apps where I have a bunch of screen-context-related controls hidden behind a "settings" type button.

## Handling TabView navigation with enums

Source: [Handle TabView data in a type-safe way with Enums \| Danijela's blog](https://www.danijelavrzan.com/posts/2023/11/create-tabview-with-enums/)

Somehow there were a lot of "Navigation-Architecture" related posts this week.

https://twitter.com/azamsharp/status/1725535808432611351

{% comment %} 
{% twitter https://twitter.com/azamsharp/status/1725535808432611351 %}
{% endcomment %}

## Enum based management of sheet navigation

Here's another post by Antoine that goes in a similar direction.
In a similar vein, there's a sample for enum based sheet transition management @twannl

https://twitter.com/twannl/status/1597940020597374976

{% comment %} 
{% twitter https://twitter.com/twannl/status/1597940020597374976 %}
{% endcomment %}

## Number transition animation

Source: [Animating number changes in SwiftUI | Sarunw](https://sarunw.com/posts/animating-number-changes-in-swiftui/)
Very pretty, but also very specific use-case of transition animation.  
If everybody starts using this, all screens that use changing numbers will have the same feel to it. 
Not sure if that's good or bad 😅

```swift
Text("\(number)")
    .contentTransition(.numericText())

Button {
    withAnimation {
        number = .random(in: 0..<200)
    }
} label: {
    Text("Random")
}
```


## Nice "hack" to have a SwiftUI `Text` always take the maximum size given to it by it's parent
Source: [swift - How to scale text to fit parent view with SwiftUI? - Stack Overflow](https://stackoverflow.com/a/57044002/2064473)

```swift
ZStack {
    Circle().strokeBorder(Color.red, lineWidth: 30)

    Text("Text")
        .padding(40)
        .font(.system(size: 500))
        .minimumScaleFactor(0.01)
     }
}
```


## In-depth article about `GeometryReader`

Source: [GeometryReader: Blessing or Curse? | by fatbobman | Better Programming](https://betterprogramming.pub/geometryreader-blessing-or-curse-1ebd2d5005ec)

## New Trait system in SwiftUI

Source: [Custom Traits and SwiftUI](https://useyourloaf.com/blog/custom-traits-and-swiftui/)
It's nice and all, but I don't quite see how they are different from EnvironmentKey, except for maybe being able to use this from both SwiftUI and UIKit.

## Infinite width frame instead of `Spacer` in SwiftUI

Source: [The alternative to SwiftUI's Spacer](https://david.y4ng.fr/the-alternative-to-swiftui-spacer/)

Either using a `Spacer`
```swift
struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
            Spacer()
            Text("Text")
        }
    }
}
```
Or a `frame` with its `width` set to infinity.
```swift
struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
            Text("Text")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
```

Seems like a choice of personal preference.

## StoreKit 2: ProductView and StoreView

Source: [Mastering StoreKit 2. ProductView and StoreView in SwiftUI. | Swift with Majid](https://swiftwithmajid.com/2023/08/08/mastering-storekit2-productview-in-swiftui/)

Another good overview article for the new features in StoreKit 2 for SwiftUI.
