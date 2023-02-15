---
layout: post
title: Adding giscus comments to my blog
category:
tags:
---

[Giscus](https://giscus.app/) is a service that enables you to have discussion-like comments and reactions on your website using GitHub's Discussion feature as a backend.  

One advantage of using Giscus over other comment systems, like Disqus, is that it leverages the existing GitHub infrastructure for user authentication. This means that users of your website can use their existing GitHub account to comment and participate in discussions, without needing to create a separate account.
Additionally, because Giscus uses GitHub's Discussion feature as a backend, your discussions will be seamlessly integrated with your repository, making it easier to manage and keep track of your discussions.

This is what the comments look like:

![giscus](/../assets/img/giscus_comments.png)

You can check it out yourself at the end of this article and leave a reaction or comment if you'd like.

Giscus provides various customization options, such as theme and language settings, to ensure that the discussion feature seamlessly integrates with your website's design and user experience. I won't be going into too much detail on these options in this article.

You can visit [https://giscus.app/](https://giscus.app/) for a relatively pain-free setup process.

If you're somehow not able to use the setup, you can utilize GitHubs CLI `gh` to run a [GraphQL](https://graphql.org/) query for the necessary information.

```shell
gh api graphql -f query='
{
  # https://github.com/github/docs

  repository(owner: "martinp7r", name: "blog") {
    id # RepositoryID
    name
    discussionCategories(first: 10) {
      nodes {
        id # CategoryID
        name
      }
    }
  }
}'
```

Response:

```json
{
  "data": {
    "repository": {
      "id": "MDEwOlJlcG9zaXRvcnkzOTM5NjM0MTc=",
      "name": "blog",
      "discussionCategories": {
        "nodes": [
          {
            "id": "DIC_kwDOF3tnmc4CT_Mp",
            "name": "Posts"
          }
        ]
      }
    }
  }
}
```

All that's left is adding a `script` tag like below to your site wherever you want the comments to display.

```html
<script src="https://giscus.app/client.js"
        data-repo="[ENTER REPO HERE]"
        data-repo-id="[ENTER REPO ID HERE]"
        data-category="[ENTER CATEGORY NAME HERE]"
        data-category-id="[ENTER CATEGORY ID HERE]"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="preferred_color_scheme"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>
```

I'm using the Jekyll theme [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy#readme) for my blog, which already has this integrated and only needs the relevant [config values](https://github.com/cotes2020/chirpy-starter/blob/85116817d18605cb14181774f798c0b37e52fdd0/_config.yml#L99-L107) to be set.
