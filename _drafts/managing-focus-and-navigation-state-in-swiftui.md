---
layout: post
title: Managing Focus and Navigation State in SwiftUI
date: 2021-12-01 08:28 +0900
category: [Articles, SwiftUI]
tags: [swiftui, swift, ios]
---

## Objective

Want to use a keyboard shortcut from anywhere in the app to show and focus a specific UI element (`TextField`).

In SwiftUI we can control the focus of a particular UI element by using the [`.focused(_:)`](https://developer.apple.com/documentation/swiftui/view/focused(_:)) or [focused(_:equals:)](https://developer.apple.com/documentation/swiftui/view/focused(_:equals:)) view modifier in connection with the [@FocusState](https://developer.apple.com/documentation/swiftui/focusstate/) property wrapper.  

```swift
struct SearchView: View {
  @FocusState private var isSearchFieldFocused: Bool

  var body: some View {
    ZStack {
      Button(action: { isSearchFieldFocused = true }, label: { Text("Search") })
          .keyboardShortcut("f", modifiers: [.command])
          .hidden()

      TextField(...)
        .focused(focusedState.$focusedItem, equals: .searchField)
      }
  }

  func focusSearch() {
    isSearchFieldFocused = true
    tabMenuState.selectedTab = .search
  }
}
```
> The hidden `Button` enables me to have the keyboard shortcut set via SwiftUI without the need for a visible control.  
> In my case the search kicks of automatically via a debounced `Combine` pipeline on the search fields binding variable.
{: .prompt-info }

Let's imagine a simple app with a top-level `TabView` navigation, where the view containing the `TextField` is located in the first tab.  
Even when I use a keyboard shortcut to focus the `TextField` while the `TabView` displays a different tab, the expected behavior would be to change the active tab to the one containing the `TextField`.


```swift
/// Tags for the TabBar menu
enum TabMenuTag: Hashable {
  case search
  // ...
  case settings
}

final class ScreenCoordinator: ObservableObject {

    var tabMenuState = TabMenuState()
    var focusedState = FocusedState()

    // MARK: - Navigation Intents

    func navigateToSearchView() {
        tabMenuState.selectedTab = .search
    }

    func focusSearch() {
        focusedState.focusedItem = .searchField
        tabMenuState.selectedTab = .search
    }
}

/// Manages the currently selected tab of the application
final class TabMenuState: ObservableObject {
    @Published var selectedTab: TabMenuTag = .search
}

struct TabMenu: View {
    @EnvironmentObject var state: TabMenuState

    var body: some View {
      TabView(selection: $state.selectedTab) {
        SearchView()
          .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
          }
          .tag(TabMenuTag.search)
      // ...
    }
}
```

Ideally, I would create something similar for managing the focused state of the app.  
After all, my keyboard shortcut is intended for use from anywhere in the app.

```swift

```

However, 

```
[SwiftUI] Accessing FocusState's value outside of the body of a View. This will result in a constant Binding of the initial value and will not update.
```

## Current solution

```swift
private struct SearchShortcutModifier: ViewModifier {
  @EnvironmentObject var tabMenuState: TabMenuState
  @FocusState private var isSearchFieldFocused: Bool

  func focusSearch() {
    tabMenuState.selectedTab = .search
    isSearchFieldFocused = true
  }

  func body(content: Content) -> some View {
    ZStack {

      Button(action: focusSearch, label: { Text("Search") })
          .keyboardShortcut("f", modifiers: [.command])
          .hidden()

      content
          .focused($isSearchFieldFocused)
    }
  }
}
```


## Caveats

Sadly, it seems that this whole mechanism only works well when looking at one single view.  
Attempting to manage the focused state of particular view elements across the app through an `ObservableObject` view-model, requires some workarounds since the `@FocusState` property wrapper will only work inside a `View`.


## References

- [](https://onmyway133.com/posts/how-to-focus-textfield-in-swiftui/)
- https://stackoverflow.com/questions/70133763/how-to-use-focusstate-with-view-models
- https://stackoverflow.com/questions/68073919/swiftui-focusstate-how-to-give-it-initial-value
