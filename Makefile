.PHONY: serve
serve:
	bundle exec jekyll serve s

.PHONY: draft
draft:
	bundle exec jekyll draft "$(filter-out $@,$(MAKECMDGOALS))"

%: 
	@:    
