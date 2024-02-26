---
layout: post
title: Decoupled stacked sheet navigation with multiple modals in SwiftUI
category:
- Articles
- iOS
tags:
- ios
- swift
- architecture
date: 2023-12-11 08:36 +0900
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

However, this limitation becomes particularly cumbersome for complex apps with features divided into separate modules, where it's imperative for the navigation to be decoupled. Ideally, subsequent screens should seamlessly transition without needing knowledge of the presenting view. Yet, in the absence of a `NavigationPath` equivalent for sheets, and considering the aforementioned error that arises when a sheet is already presented, finding a good solution in SwiftUI's present state is not straightforward.

## Solution

Our app has an onboarding view presented as a sheet at first launch. The onboarding view itself contains a button that presents a sheet with items the user may download. This is what we want to achieve:

<center>
<video controls="" autoplay="" name="media" width="250px" loop align="center"><source src="https://i.imgur.com/PkGdFiI.mp4" type="video/mp4"></video>
</center>

> The basic navigation concept of the example below with `Router` and `SheetDestination` is taken from the Icecubes Mastodon app.  
> It's [open-sourced on GitHub](https://github.com/Dimillian/IceCubesApp) and contains many more interesting architectural ideas.  
> I highly recommend checking it out!
{: .prompt-info }

We define the destinations within an `enum` inside a `Navigation` module that also holds our `Router`:

```swift
public enum SheetDestination: Identifiable {
    case download
    case onboarding
}
```

Inside our Router we only care about assigning the destinations to available sheets for presentation:
```swift
@Observable
Router {
    public var presentedSheet: Sheet?
    public var presentedSheet2: Sheet?

    public func present(sheet: Sheet) {
        if presentedSheet == nil {
            presentedSheet = sheet
        } else {
            presentedSheet2 = sheet
        }
    }
}
```

In our root app, we wire up the `Router` and sheet presentation, and decide which views to present for our destinations.
```swift
import Downloads
import Navigation
import Onboarding

public struct MyApp: App {
    @Bindable private var router = Router()

    public var body: some Scene {
        WindowGroup {
            ContentView()
        ˆ       .sheet(item: $router.presentedSheet) { destination1 in
                    view(for: destination1)
                        .sheet(item: $router.presentedSheet2) { destination2 in
                            view(for: destination2)
                        }
                }
        }
        .environment(router)
    }

    @ViewBuilder
    private func view(for destination: SheetDestination) -> some View {
        switch destination {
        case .download: DownloadView()
        case .onboarding: OnboardingView()
        }
    }
}
```

Wherever we want to present a view as a sheet from within our app we only need to import the `Navigation` module. In our example the separated `Onboarding` and `Downloads` modules don't need to know about each other. The only requirement is that they are both dependencies of the root app.

```swift
import Navigation

// ...

@Environment(Router.self) private var router

// ...

Button("Open Downloads") {
    router.present(sheet: .download)
}
```

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
