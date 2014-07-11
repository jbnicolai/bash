# vim: set ft=sh:
# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@"
	}
fi

# Change desktop background to screensaver
function screensaver() {
    /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background &
}

# And kill the process
function screensaverkill() {
    killall ScreenSaverEngine
}

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -m "SimpleHTTPServer" "$port"
}

function smtpserver() {
	local port="${1:-1025}"
    python -m smtpd -n -c DebuggingServer localhost:"$port"
}

function translate() {
    wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" \
        | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/';
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}"
	local ip=$(ipconfig getifaddr en1)
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}"
}

function gmail() {
    curl -u "joshuaappelmanisawesome" --silent "https://mail.google.com/mail/feed/atom" | perl -ne 'print "\t" if /<name>/; print "$2\n" if /<(title|name)>(.*)<\/\1>/;'
}

# Get gzipped file size
function gz() {
	echo "orig size (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# Test if HTTP compression (RFC 2616 + SDCH) is enabled for a given URL.
# Send a fake UA string for sites that sniff it instead of using the Accept-Encoding header. (Looking at you, ajax.googleapis.com!)
function httpcompression() {
	encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using ${encoding#* }" || echo "$1 is not using any encoding"
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
	python -m json.tool | pygmentize -l javascript
}

# All the dig info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	echo # newline
}

# Get a character’s Unicode code point
function codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
	echo # newline
}

# Manually remove a downloaded app or file from the quarantine
function unquarantine() {
	for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine; do
		xattr -r -d "$attribute" "$@"
	done
}


# Symlink all dotfiles in the directory to the home directory
function linkdotfiles() {
    find . -type f -name ".*" -exec ln -f '{}' ~ ';'
}

# npm publish with goodies
# prerequisite: `npm install -g trash`
# `np` with an optional argument `patch`/`minor`/`major`/`<version>`
# defaults to `patch`
np() {
  trash node_modules &>/dev/null;
  git pull --rebase && \
  npm install && \
  npm test && \
  npm version "${1:-patch}" && \
  npm publish && \
  git push --follow-tags
}
