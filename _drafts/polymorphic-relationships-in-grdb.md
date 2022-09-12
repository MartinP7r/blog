---
layout: post
title: Polymorphic Relationships in GRDB
date: 2021-11-11 12:44 +0900
---

How would one go about designing an association (relationship) in Swift with SQLite that can be associated with several different types.
A similar thing exists in `Ruby on Rails` or `Laravel`'s Eloquent ORM where it is called [Polymorphic Relationships](https://laravel.com/docs/8.x/eloquent-relationships#polymorphic-relationships).

Where you'd have for example a `Note` type which could be attached as a One-To-One relationship to either 


