for file in ~/.bash_{path,prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file
