#!/bin/bash

cd Pending

# Iterate over all .html files in the current directory
for f in *.html; do
    # Check if the file exists (in case the folder is empty)
    [ -e "$f" ] || continue

    # --- STEP 1: Rename ---
    new_name=$(echo "$f" | sed -E 's/ - SRB2 Wiki//g; s/ \([^)]*\)\.html$/.html/; s/ /_/g')
    
    if [ "$f" != "$new_name" ]; then
        mv "$f" "$new_name"
    fi

    # Step 2: "href=https://wiki.srb2.org/wiki/content" -> "href=content.html"
    sed -i -E 's|href=https://wiki\.srb2\.org/wiki/([^[:space:]">:]+)|href=\1.html|g' "$new_name"

    # Step 3: "href=content#maps.html" -> "href=content.html#maps"
    sed -i -E 's|href=([^[:space:]">:]+)#([^[:space:]">:]+)\.html|href=\1.html#\2|g' "$new_name"

    # --- STEP 4: Replace '/' with '_' in local hrefs ---
    # This loop searches for '/' strictly inside hrefs that DO NOT contain a ':'
    sed -i -E ':a; s|(href="?[^[:space:]">:]*)/([^[:space:]">:]*)|\1_\2|g; ta' "$new_name"

    echo "Processed: $new_name"
done

mv * "../SRB2 Wiki"

echo "HTML to local done. Moved to SRB2 Wiki folder."