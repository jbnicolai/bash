PWD = `pwd`
LINKS =".bash_aliases"  \
	".bash_completion_maven" \
	".bash_exports" \
	".bash_extra" \
	".bash_functions" \
	".bash_logout" \
	".bash_path" \
	".bash_profile" \
	".bash_prompt" \
	".bashrc" \
	".inputrc" \
	".powerline-bash.py"

all: link

link:
	for file in $(LINKS); do \
		ln -sf "$$PWD/$$file" ~/"$$file"; \
	done
