---
layout: post
title: Iterating enums containing nested associated enums
category:
- Snippets
- Swift
tags:
- swift
date: 2022-11-04 20:04 +0900
---
Swift's `CaseIterable` protocol automatically generates an array with all cases for a given `enum` that **doesn't contain any cases with associated values**.  

So, the below won't work:
```swift
enum Category: CaseIterable {
    case all
    case none
    case level(Level)
}
```
With the error:
> Type 'Category' does not conform to protocol 'CaseIterable'
{: .prompt-danger }

It still won't work if the associated values are restricted to `CaseIterable` `enums`.  

```swift
enum Level: CaseIterable {
    case one, two, three
}
```

Howerver, you can still somewhat cleanly achieve an iteration of all the values by assembling the parent `allCases` static property manually.   

```swift
enum Level: CaseIterable {
    case one, two, three
}

enum Category: CaseIterable {
    static var allCases: [Category] {
        [.all, .none] + Level.allCases.map { Category.level($0) }
    }

    case all
    case none
    case level(Level)
}

Category.allCases.forEach { print($0) }
/* Output:
all
none
level(__lldb_expr_16.Level.one)
level(__lldb_expr_16.Level.two)
level(__lldb_expr_16.Level.three)
*/
```

In this case it won't automatically account for new cases in the parent, though.
