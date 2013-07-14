for file in ~/.bash_{path,prompt,exports,aliases,functions,extra,completion_maven,completion_git}; do
	[ -r "$file" ] && source "$file"
done
unset file
