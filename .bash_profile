for file in ~/.bash_{path,prompt,exports,aliases,functions,extra,completion_maven}; do
	[ -r "$file" ] && source "$file"
done
unset file
