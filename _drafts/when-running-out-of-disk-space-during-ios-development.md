---
layout: post
title: When running out of disk space during iOS development
category:
tags:
---

Just a little update which might help you if your System Data folder takes up most of their disk space (i.e. 100s of GB; like me, see above) and DevCleaner didn't help.
After some research, I found that It actually was mostly ~/Library/Developer/CoreSimulator data. DevCleaner did not clean these files. Thanks to 
@ras
 for pointing me in the right direction.
I was able to free up 400GB of disk space by completely nuking my Simulator devices, images and caches.
Depending on your situation, you might not need or want all the steps I took, but here they are in order of boldness (I'm not responsible if you break anything on your machine :sweat_smile:)
xcrun simctl delete unavailable : will delete all simulator devices that are still on disk, but are not available for use anyway
Delete unnecessary Simulator images via Xcode > Settings > Platform (if you try out many Xcode betas, there might be lots to delete here). (info: these are located in /Library/Developer/CoreSimulator/images but hard to distinguish b/c file names are only UUIDs, so better delete from Xcode settings)
xcrun simctl delete all : deletes all devices, you will have to create new ones
Delete contents of the folders below AND RESTART YOUR MACHINE (and uninstall/reinstall your version of Xcode)
 ~/Library/Developer/CoreSimulator
 /Library/Developer/CoreSimulator (you will need to re-download device images from within Xcode)
