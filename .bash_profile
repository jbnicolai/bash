for file in ~/.bash_{path,prompt,exports,functions,extra,completion_maven,completion_git,aliases,local}; do
	[ -r "$file" ] && source "$file"
done
unset file
