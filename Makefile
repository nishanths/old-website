JEKYLL := bundle exec jekyll
SRCDEST := --source site --destination out

# make changes to styles/content.
# then 'make' to build changes.
# then commit your changes.
# then 'make publish' to push to GitHub Pages.

.PHONY: default
default: b

.PHONY: b
b: clean
	$(JEKYLL) build $(SRCDEST)

.PHONY: s
s: clean
	$(JEKYLL) serve $(SRCDEST)

.PHONY: clean
clean:
	rm -rf out/

.PHONY: draft
draft:
	# usage: make draft t="My Title"
	# then move the file to site/_posts/ when done
	$(JEKYLL) draft $(t) --source site

.PHONY: deps
deps:
	bundle install --path vendor/bundle

.PHONY: publish
publish:
	# it seems like out/ should have been committed at least once for this
	# to work
	git branch -D master
	git subtree split --prefix out/ -b master
	git push -f origin master:master
