PWD = `pwd`
LINKS=$(shell ls -A | grep ^\\.)

all: link

link:
	for file in $(LINKS); do \
		[ -f $$file ] && [ $$file != ".git" ] && ln -sf "$$PWD/$$file" ~/"$$file"; \
	done
