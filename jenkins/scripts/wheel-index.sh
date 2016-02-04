#!/bin/bash -xe

# Working variables
MIRROR_ROOT=$1

# A temporary file to which to write the new index
TMP_INDEX_FILE=$(tempfile)
trap "rm -f -- '$TMP_INDEX_FILE'" EXIT

# And the final location
INDEX_FILE=${MIRROR_ROOT}/index.html

# Start building our file
echo -e "<html>\n  <head>\n    <title>Wheel Index</title>\n  </head>" > $TMP_INDEX_FILE
echo -e "  <body>\n    <ul>" >> $TMP_INDEX_FILE

# Get a list of files
FILES=`find $MIRROR_ROOT -maxdepth 2 -type d`
REGEX="([^/])\/($1[^/]+)$"
for f in $FILES; do
    if [[ $f =~ $REGEX ]]; then
        echo "      <li><a href=\"./${BASH_REMATCH[2]}/\">${BASH_REMATCH[2]}</a></li>" >> $TMP_INDEX_FILE
    fi
done

echo -e "    </ul>\n  </body>\n</html>" >> $TMP_INDEX_FILE

# Atomically replace the index file
mv $TMP_INDEX_FILE $INDEX_FILE

# The tempfile is gone so we don't need the trap
trap - EXIT
