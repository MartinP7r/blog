---
layout: post
title: Newsletter Summaries Week 45 (2023)
category: Newsletter
tags: 
- swift
- swiftui
---

# Motivation

I'm going to try something as a motivation to read more of the Swift/programming related newsletters I subscribe to.  
I want to post some articles and socials about Swift/Apple/iOS programming I found throughout the week.
This may not follow a specific schedule, but I want to try to get one out per week.

# Summaries

[GitHub - danielsaidi/SwiftUIKit: SwiftUIKit contains additional functionality for SwiftUI.](https://github.com/danielsaidi/SwiftUIKit)  
This package with extensions and UI components for SwiftUI looks interesting.  
But there's no demo application?

[Enhancements to ScrollView in iOS 17 - YouTube](https://link.sbstck.com/redirect/8f3b3c67-a393-4034-a842-b3fbe1f785d9?j=eyJ1IjoiMTBicDltIn0.gc2PL8KPmV8T2FCc0plLjgn2ugpw71bl7jAM4TVfPbE)  
`HScrollContent` seems interesting, although I don't see a direct use case for it right now. 🤔
Something where the entire scroll view's content needs to be formatted as one.

[SwiftUI Sheet Matched Geometry Effect - Hero Animation - Custom Matched Geometry - iOS 17 - Xcode 15 - YouTube](https://www.youtube.com/watch?v=zHtB8mHPLDU)  
This might be interesting for [[Jibiki]] if I want to create matched animation for a dedicated Kanji list screen?

[Hierarchical background styles in SwiftUI](https://nilcoalescing.com/blog/HierarchicalBackgroundStyles/)  
Nice that we can use them, but I'm not good at design and have no clue when to use secondary or other hierarchical backgrounds... 😅

[Building Complex Scroll Animations With New iOS 17 API's - Xcode 15 - YouTube](https://www.youtube.com/watch?v=ytRim2TSdyY)  
Very nice animations. definitely watch this one.

## Pagination with SwiftUI List

[How to implement pagination with SwiftUI's List view](https://tanaschita.com/20230828-pagination-in-swiftui-list/)

```swift
List {
    ForEach(viewModel.items, id: \.id) { item in
        ListItemView(item: item)
    }
    if viewModel.isMoreDataAvailable {
        lastRowView
    }
}

var lastRowView: some View {
    ZStack(alignment: .center) {
        switch viewModel.paginationState {
        case .isLoading:
            ProgressView()
        case .idle:
            EmptyView()
        case .error(let error):
            ErrorView(error)
        }
    }
    .frame(height: 50)
    .onAppear {
        viewModel.loadMoreItems()
    }
}
```

## AppStorage persistable Codable values

[Store Codable types in AppStorage | Daniel Saidi](https://danielsaidi.com/blog/2023/08/23/storagecodable)  
Interesting usage of `RawRepresentable` (iOS 15+) to make types that implement `Codable` automatically persist-able via `AppStorage` property wrapper.

## Prepare for Swift 6

[Swift 6: Preparing your Xcode projects for the future - SwiftLee](https://www.avanderlee.com/concurrency/swift-6-preparing-your-xcode-projects/)

- async/await
- existentials
- other warnings (implicit imports?)

## Opaque generic arg instead of generic type constraint

[Vincent Pradeilles on X: "Looking for a quick tip to improve your Swift code? 🤨 Since Swift 5.7 functions can declare opaque generic arguments by using the keyword \`some\`! This new syntax offers a simpler alternative to the good old generic constraint 👌 https://t.co/8WY1blWnMs" / X](https://twitter.com/v_pradeilles/status/1721506032646869355?s=20)
```swift
func fu(bar: some Identifiable) {}
// instead of
func fu<T: Identifiable>(bar: T) {}
```
But there's some caveats, for example 
- debugging is currently buggy with the opaque type version
- where clause constraints are not possible

## Paywall cancellation survey

[from twitter](https://twitter.com/4bh1nav/status/1721501811591254064)
