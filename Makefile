.PHONY: serve
serve:
	bundle exec jekyll serve --drafts

.PHONY: draft
draft:
	bundle exec jekyll draft "$(filter-out $@,$(MAKECMDGOALS))"

.PHONY: publish
publish:
	bundle exec jekyll publish "$(filter-out $@,$(MAKECMDGOALS))"

%: 
	@:    
