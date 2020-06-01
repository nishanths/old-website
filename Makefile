JEKYLL := bundle exec jekyll
SRCDEST := --source site --destination out

# commit changes to styles and website content.
# then 'make' to build changes.
# then 'make publish' to push to GitHub Pages.

# requires 'make' supporting .ONESHELL (v3.82 or higher).

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

.PHONY: deprecated-publish
deprecated-publish:
	# it seems like out/ should have been committed at least once for this
	# to work
	git branch -D master
	git subtree split --prefix out/ -b master
	git push -f origin master:master

.PHONY: publish
.ONESHELL:
publish:
	rm -rf out/.git
	cd out
	git init
	git checkout master
	git remote add origin git@github.com:nishanths/nishanths.github.io.git
	git add -A
	GIT_AUTHOR_NAME='hardworking bot' GIT_AUTHOR_EMAIL='hardworking-bot@littleroot.org' \
		GIT_COMMITTER_NAME='hardworking bot' GIT_COMMITTER_EMAIL='hardworking-bot@littleroot.org' \
		git commit -m 'push'
	git push -f origin master:master

.PHONY: p
p: publish
