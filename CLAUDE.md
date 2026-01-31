# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

This is a Jekyll-based personal tech blog using the Chirpy theme, focused on iOS, Swift, and web development topics. Hosted on Netlify at https://blog.martinp7r.com.

## Build & Development Commands

```bash
# Install dependencies
bundle install

# Start local dev server with drafts
bundle exec jekyll serve --drafts
# or use:
make serve

# Build for production
bundle exec jekyll build

# Create a new draft post
make draft "Article Title"

# Publish a draft
make publish "Article Title"
```

## Project Structure

- `_posts/` - Published blog articles (YYYY-MM-DD-title.md format)
- `_drafts/` - Draft articles (not published)
- `_tabs/` - Navigation tabs (about, archives, tags, categories)
- `_includes/` - Reusable HTML/template partials
- `_data/` - YAML data files for templates
- `_sass/` - Custom style overrides
- `assets/` - Images, CSS, JS assets
- `_config.yml` - Main Jekyll configuration

## Writing Posts

Posts use Jekyll front matter with these common fields:
```yaml
---
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS +0000
categories: [Category1, Category2]
tags: [tag1, tag2]
---
```

## Tech Stack

- **Framework**: Jekyll (Ruby)
- **Theme**: jekyll-theme-chirpy v6.3
- **Ruby Version**: 3.0.5
- **Hosting**: Netlify
- **Comments**: Giscus (GitHub Discussions)
