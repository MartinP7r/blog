---
layout: post
title: App State with UserDefaults and Keypath Publishers
category:
  - Articles
  - Swift
tags:
  - swift
  - ios
---

Inspired by 
https://swiftwithmajid.com/2019/09/04/modeling-app-state-using-store-objects-in-swiftui/


## Problem

`.publisher(for: UserDefaults.didChangeNotification)` will fire for *every* change to a property stored in `UserDefaults`, even for properties that have nothing to do with our app-wide user settings, which includes values from Apple that are stored there as well. 

## Solution

Implement a separate notification pipeline for every settings value.

## Implementation

We define a property on UserDefaults to be able to create a KVO-based publisher.
```swift
public extension UserDefaults {
  @objc dynamic var accentColor: String? {
    get { string(forKey: SettingsStore.Keys.accentColor) }
    set { set(newValue, forKey: SettingsStore.Keys.accentColor) }
  }
}
```

A global store for app-wide settings that conforms to `ObservableObject` and will be injected into the environment.

```swift
public final class SettingsStore: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        subscribeUpdates(for: \.accentColor)
        subscribeUpdates(for: /* ... */)
    }
}
```


```swift
private func subscribeUpdates<T: Equatable>(
    for defaultsKeyPath: ReferenceWritableKeyPath<UserDefaults, T>
) {
    defaults.publisher(for: defaultsKeyPath)
        .removeDuplicates()
        .map { _ in }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in self?.objectWillChange.send() }
        .store(in: &subscriptions)
}
```

A property on `SettingsStore` exposing the setting's value and 
```swift
public var accentColor: AccentColor {
    get { AccentColor(rawValue: defaults.accentColor ?? "") ?? .blue }
    set { defaults.accentColor = newValue.rawValue }
}
```
> The `AccentColor` type is a simple `enum`.
{: .prompt-info }

With the above in place, the only thing we need to do when we want to add a new persited property to our settings is to define the property on `UserDefaults` and `SettingsStore` and call the `subscribeUpdates(for:)` with the new keypath.


## Appendix

The `AccentColor` type mentioned above:
```swift
public enum AccentColor: String, Codable, CaseIterable {
    case blue, orange, red, green, teal, yellow
}
```

With a convenience extension to give us the appropriate `Color` in `SwiftUI`.

```swift
import SwiftUI

extension AccentColor {
    var color: Color {
        switch self {
        case .blue: return .blue
        case .orange: return .orange
        case .red: return .red
        case .green: return .green
        case .teal: return .teal
        case .yellow: return .yellow
        }
    }
}
```
