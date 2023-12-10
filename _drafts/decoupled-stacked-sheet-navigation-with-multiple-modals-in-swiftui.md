---
layout: post
title: Decoupled stacked sheet navigation with multiple modals in SwiftUI
category:
tags:
---

## Problem

I don't think this is a particularly rare use case, but recently I wanted to implement two modal sheets where the second one is displayed on top of the first one.


```swift
ContentView()
    .sheet(isPresented: $showOnboarding) {
        OnboardingView() 
    }
    .sheet(isPresented: $showDownloads) {
        DownloadView()
    }
```

But when trying to present multiple sheets from a single root view as shown above, I'm met with this frustrating error message:

```console
Currently, only presenting a single sheet is supported.  
The next sheet will be presented when the currently presented sheet gets dismissed.
```

The quick solution here is to present the second sheet from within the first sheet as outlined in [this *Hacking With Swift* post](https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-multiple-sheets).

```swift
ContentView()
    .sheet(isPresented: $showOnboarding) {
        OnboardingView()
            .sheet(isPresented: $showDownloads) {
                DownloadView()
            }
    }
```

However, this limitation becomes particularly cumbersome for complex apps with features divided into separate modules, where it's imperative for the navigation to be decoupled. Ideally, subsequent screens should seamlessly transition without needing knowledge of the presenting view. Yet, in the absence of a `NavigationPath` equivalent for sheets, and considering the aforementioned error that arises when a sheet is already presented, implementing an elegant solution in SwiftUI's present state is not straightforward. 

## First Iteration

The basic navigation concept I'm using below is taken from the Icecubes Mastodon app. 
It's [open-sourced on GitHub](https://github.com/Dimillian/IceCubesApp) and contains many more interesting architectural ideas.  
I highly recommend checking it out!

```swift
public enum SheetDestination: Identifiable {
    case download
    case onboarding
    // ...
}

func registerSheet(
    for destination: Binding<SheetDestination?>,
    _ secondDestination: Binding<SheetDestination?>? = nil
    // add more if needed
) -> some View {
    sheet(item: destination) { destination1 in
        view(for: destination1)
            .unwrap(secondDestination) { view1, destination2 in
                view1
                    .sheet(item: destination2) { destination2 in
                        view(for: destination2)
                    }
            }
    }
}

@ViewBuilder
private func view(for destination: SheetDestination) -> some View {
    switch destination {
    case .download: DownloadView()
    case .onboarding: OnboardingView()
    }
}

// call site: App root
    public var body: some Scene {
        WindowGroup {
            // ...
            .registerSheet(
                for: $router.presentedOnboardingScreen, 
                $router.presentDownloadScreen
            )
            // ...

// call site: module containing Onboarding view
    Button("Open Downloads") {
        router.presentedSheet2 = .download
    }
```
<center>
<video controls="" autoplay="" name="media" width="250px" loop align="center"><source src="https://i.imgur.com/PkGdFiI.mp4" type="video/mp4"></video>
</center>

Here the order of views and actual presentation is controlled by the upstream application which is allowed to "see" both of the feature modules. The separate modules for `OnboardingView` and `DownloadView` don't need to know about each other.  

This solution is obviously a little "dumb", and it would be nicer to have it actually scale and be dynamically applicable to as many sheets as we want to stack. So we could look into making that happen, perhaps with recursion and existential generics. The newly introduced variadic [Parameter Packs](https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md) might be helpful as well.  
However, when would we actually need more than 2 or 3 sheets stacked on each other?  
So I think the manual way of just adding another parameter does the trick quite well and the signature of my method above is designed so it looks essentially like a variadic parameter at the call site. With no cost for the consumer if we actually choose to migrate it in the future.

<!-- ## AnyView Nightmare

```swift
func regVari(destinations: Binding<SheetDestination?>...) -> some View {
    if destinations.count == 1, let first = destinations.first {
        return AnyView(erasing: sheet(item: first) { destination in
            view(for: destination)
        })
    } else {
        var currentView = AnyView(self)
        for destination in destinations {
            currentView = AnyView(currentView.sheet(item: destination) { destination in
            })
        }
        return AnyView(erasing: currentView)
    }
}
```
 -->
