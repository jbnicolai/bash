for file in ~/.bash_{path,prompt,exports,functions,extra,completion_maven,completion_git,aliases}; do
	[ -r "$file" ] && source "$file"
done
unset file
