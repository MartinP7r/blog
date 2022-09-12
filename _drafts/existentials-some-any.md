---
layout: post
title: Existentials, some & any
category:
tags:
---

- `some` specifies the use of an opaque type
- `any` specifies the use of an existential type

`any` is not mandatory at this point, but form Swift 6 onwards it's planned to result in an error if you fail to mark an existential type with it.

```swift
protocol Vehicle {
    func travel(to destination: String)
}

struct Car: Vehicle {
    func travel(to destination: String) {
        print("I'm driving to \(destination)")
    }
}

func travel<T: Vehicle>(to destinations: [String], using vehicle: T) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}


let vehicle = Car() // <-- static dispatch possible because vehicle will always be of type car and the compiler knows it
// vehicle.travel(to: "London")
travel(to: ["London", "Amarillo"], using: vehicle)

let vehicle2: Vehicle = Car() // <-- car stored in `Vehicle` "box", no static dispatch possible
// `Vehicle` here is an existential type
// vehicle2.travel(to: "Glasgow")

```



## List of articles about `some` and `any`

- https://www.donnywals.com/whats-the-difference-between-any-and-some-in-swift-5-7/
- https://www.swiftbysundell.com/articles/referencing-generic-protocols-with-some-and-any-keywords/
- https://onmyway133.com/posts/how-to-use-any-vs-some-in-swift/

- https://www.hackingwithswift.com/swift/5.6/existential-any


> An “existential type” allows us to say what kind of functionality we want a type to have rather than requesting something specific.[^fn-hws-existential]


[^fn-hws-existential]: https://www.hackingwithswift.com/articles/106/10-quick-swift-tips
