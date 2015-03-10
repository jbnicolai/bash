for file in ~/.bash_{path,prompt,exports,colours,functions,extra,completion_maven,completion_git,aliases,local,commacd}; do
	[ -r "$file" ] && source "$file"
done
unset file
