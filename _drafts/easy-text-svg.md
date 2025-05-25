---
layout: post
title: Easy Text SVG
category:
tags:
---


```xml
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg" viewBox="-512 -512 1024 1024">
    <defs>
        <filter id="drop-shadow">
            <feGaussianBlur in="SourceAlpha" stdDeviation="6" />
            <feOffset dx="6" dy="6" result="offsetblur" />
            <feFlood flood-color="rgba(0,0,0,0.7)" />
            <feComposite in2="offsetblur" operator="in" />
            <feMerge>
                <feMergeNode />
                <feMergeNode in="SourceGraphic" />
            </feMerge>
        </filter>
    </defs>

    <g transform="rotate(-45)">
        <text x="0" y="0"
            font-family="Hiragino Maru Gothic ProN, sans-serif"
            font-weight="bold"
            font-size="916"
            fill="rgba(222,154,74,1)"
            filter="url(#drop-shadow)"
            text-anchor="middle"
            dominant-baseline="central"
        >
            字
        </text>
    </g>
</svg>
```
