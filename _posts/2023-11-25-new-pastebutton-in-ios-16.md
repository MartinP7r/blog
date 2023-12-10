---
layout: post
title: New PasteButton in iOS 16
category:
tags:
date: 2023-11-25 15:45 +0900
---
iOS 16 introduced a new SwiftUI button called [`PasteButton`](https://developer.apple.com/documentation/swiftui/pastebutton).

Previously, when trying to paste content from another application, users were prompted for permission on every single paste operation unless a per-app system setting is manually changed by the user. This could quickly become cumbersome and disrupt the flow of tasks. However, iOS 16 addresses this issue by introducing `PasteButton`.

PasteButton allows to paste content of a specified type from the clipboard without the need to ask the user for permission. This is because, unlike other apps, developers cannot tamper with the pasteboard contents.

The button only active when the system's Pasteboard (`UIPasteboard`) has an actual payload of the requested content type available for pasting. This helps users easily identify when the PasteButton can be utilized.

<video controls="" autoplay="" name="media" width="720px" loop><source src="https://i.imgur.com/i4rUDSi.mp4" type="video/mp4"></video>

While the PasteButton proves to be a useful addition to SwiftUI, it does have some limitations in terms of visual customization. Developers can modify the button's appearance using [`.buttonBorderShape(...)`](https://developer.apple.com/documentation/swiftui/view/buttonbordershape(_:)), [`labelStyle(_:)`](https://developer.apple.com/documentation/swiftui/view/labelstyle(_:)), and [`tint(_:)`](https://developer.apple.com/documentation/swiftui/view/tint(_:)-93mfq). Unfortunately, there doesn't seem to be an option to display just the paste icon symbol without a border.

```swift
PasteButton(payloadType: String.self) { strings in
    guard let string = strings.first else {
        return
    }
    text = string
}
.buttonBorderShape(.capsule)
.labelStyle(.iconOnly)
.tint(.red)
```

![Examples of customized PasteButton](https://i.imgur.com/8y8yWVG.png)
