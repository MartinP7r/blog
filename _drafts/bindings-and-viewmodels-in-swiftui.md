---
layout: post
title: Bindings and ViewModels in SwiftUI
date: 2021-10-09 18:19 +0900
tags: swiftui swift mvvm
category: Articles
---

## The Problem

When implementing MVVM with SwiftUI and Combine, we often use an `ObservableObject` as the **V**iew**M**odel. 

As an example, imagine a view with a `TextField` and a `Text` view that displays the latest value of the `TextField` with more than three characters. 

```swift
import Combine
import SwiftUI

struct SampleView: View {
    @StateObject var vm = ViewModel()

    var body: some View {
        Self._printChanges()
        return VStack {
            TextField("placeholder", text: $vm.inputText)
            Text(vm.outputText)
        }
    }
}

class ViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var outputText: String = ""

    init() {
        $inputText
            .filter({ $0.count > 3 })
            .assign(to: &$outputText)
    }
}
```

> info ""
> `_printChanges()` is a neat addition in iOS 15, which prints the names of the properties that changed and caused the view to refresh. 
> As well as `@self` when the view itself changed and `@identity` when the identity of the view changed.
> E.g. it will print `SampleView: @self, @identity, _vm changed.` on init and `SampleView: _vm changed.` every time the view-model forces the view to change.

Anytime a `@Published` property is changed, its ObservableObject notifies the observing view that it needs to refresh.  
However, in the example above, there's no need to update the view for input values shorter than four characters.
Even though SwiftUI is smart enough to decide which sub-views it needs to redraw by evaluating the type of the view's body, I think the use of `@Published` here is inappropriate.

## A Solution

In the example below, we use a `CurrentValueSubject` which does not cause the `ObservableObject` to update.
However, our `TextField` demands a `Binding` for its `text` parameter, so we manually create one that *get*s the filtered `outputText` and *set*s the value of our `CurrentValueSubject`.

```swift
struct SampleView: View {
    @StateObject var vm = ViewModel()

    var body: some View {
        Self._printChanges()
        return VStack {
            TextField("placeholder",
                      text: Binding(get: { vm.outputText },
                                    set: { vm.inputSubject.value = $0 }))
            Text(vm.outputText)
        }
    }
}

class ViewModel: ObservableObject {
    let inputSubject = CurrentValueSubject<String, Never>("")
    @Published var outputText: String = ""

    init() {
        inputSubject
            .filter({ $0.count > 3 })
            .assign(to: &$outputText)
    }
}
```

## Caveats

The proposed solution creates a split binding for our TextField. It will not react to changes to `inputSubject` from the outside.
For our unidirectional design this is actually what we want, but it might not be depending on what the requirements are.
Having the `Binding` in the view is not very pretty.

## Strange Errors

I came across this [@Input](https://www.swiftbysundell.com/articles/connecting-and-merging-combine-publishers-in-swift/) property wrapper on the [Swift By Sundell Blog](https://www.swiftbysundell.com) which intends to solve precisely the problem we stated above.

```swift
@propertyWrapper
struct Input<Value> {
    var wrappedValue: Value {
        get { subject.value }
        set { subject.send(newValue) }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }

    private let subject: CurrentValueSubject<Value, Never>

    init(wrappedValue: Value) {
        subject = CurrentValueSubject(wrappedValue)
    }
}
```

However, using this wrapper in place of our "split Binding" leads to strange behavior I haven't fully understood yet but wanted to share.  
For one, it prints many lines of the following message 
`Binding<String> action tried to update multiple times per frame.`

Further, the `TextField` itself seems to "stutter" because of it. This becomes especially clear when using Japanese input.
For example, trying to write の (the kana 'no') will result in nお (n followed by the kana for 'o'), which should normally not happen because 'no' will be automatically transformed to 'の'.

![video](/assets/input_binding_bug.mp4){: width="250" }
