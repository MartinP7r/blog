---
layout: post
title: MV Architecture & Scalable Tests
category:
- Articles
- SwiftUI
tags:
- ios
- swift
- swiftui
- architecture
---

## Introduction

This post is about some additional considerations I thought of when reading [this very good article](https://swiftandtips.com/is-mvvm-necessary-for-developing-apps-with-swiftui) by Pedro Rojas about the recent buzzword architecture **"MV"**, trying to get rid of the MVVM style ViewModel in our SwiftUI apps' architecture.

I invite you to read the article yourself, as it's very good and 
The most important notion being that in the declarative UI framework that is SwiftUI, the `View` is not actually 

Especially this part made it somewhat click for me as well:

> Your View defines what the view should contain, but not how it will look.
> 
> In fact, that's why SwiftUI was designed to use property wrappers to manage the state inside the views. If you think about it, a SwiftUI View, is actually equivalent to a ViewModel in MVVM! 🤯
> 
> This is key to understanding why using ViewModels from MVVM is redundant: You create a ViewModel inside a ViewModel 🔥.


> Now, the question is, what will happen if the view requires managing some internal logic that ViewModel used to handle?
> 
> Simply, for those cases, @State will be a perfect fit for that!

## Problem statement

- Preview testing does not scale well as we can't automate it outside of snapshot tests.
- 

## Solutions



## One more ~~Thing~~ Problem

## What to do

Why is this OK? Because it's local `@State`!  
So we went full circle on this one, I guess.

---
### memo

**SwiftUI mvvm mismatch**
View is a value type
Doesn't have state (not really)
Body is called and actual view is generated
State is "injected" though property wrappers

!!!: concept of ViewModel as stateless function of the dependencies? - wouldn't work, we need state

If we add the view-isolated logic to an extension of that Observable model, we can have the best of both worlds.

The extension effectively becomes the view model.

The only remaining issue is 

---

- scaling tests in multi module apps
- won't work with UI tests that need one more screenshot
	- not only for the state the UI is in, but also for possible variations of input to the logic that drives the UI changes
- want to test sufficiently
- testing simple `@State` logic like dialog or sheet display boolean flags is not needed and can be covered by VRT (visual regression testing)
- Scalability in multi module
