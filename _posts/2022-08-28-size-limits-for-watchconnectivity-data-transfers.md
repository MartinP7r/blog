---
layout: post
title: Size-Limits for WatchConnectivity data transfers
category:
- Articles
- Projects
tags:
- watchOS
date: 2022-08-28 15:14 +0900
---
<!-- There are several ways to transfer data between iOS and watchOS.  
Each has different use cases and the documentation is somewhat descriptive about them.  
E.g. not using `sendMessage()` for critical data because it's left to the system to decide when to send it, 
`updateApplicationContext()` will only keep the latest state, so sending two different packets of data with it will overwrite the first one. 
Etc...

It' -->

## [WCErrorCodePayloadTooLarge](https://developer.apple.com/documentation/watchconnectivity/wcerrorcode/wcerrorcodepayloadtoolarge)

I tried to send some data from the companion app to my watchOS application and ran into this error.  
Neither the error message itself, nor the documentation gives any indication of what the size limit should actually be.

Thankfully someone on stackoverflow had a look at the private symbols relating to that error message: [https://stackoverflow.com/a/35076706/2064473](https://stackoverflow.com/a/35076706/2064473)

- **65,536 bytes** (65.5 KB) for [`sendMessage(_:replyHandler:errorHandler:)`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1615687-sendmessage/)
- **65,536 bytes** (65.5 KB) for [`transferUserInfo(_:)`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1615671-transferuserinfo)
- **262,144 bytes** (262.1 KB) for [`updateApplicationContext(_:)`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1615621-updateapplicationcontext)

However, because application context is not suitable for my particular use case, it seems the surest way to guarantee my data is transferred, short of writing some complicated checks and splitting data, is to use [`transferFile(_:metadata:)`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1615667-transferfile).
