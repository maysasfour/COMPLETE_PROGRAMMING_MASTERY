#!/usr/bin/env bash
# Downloads the public-domain SQLite "amalgamation" (a single sqlite3.c + sqlite3.h pair
# that IS the entire SQLite library, no separate build system needed) so this mini-project
# can compile SQLite as a plain SwiftPM C target -- see the README's "Why vendor SQLite
# source instead of linking a system library" section for the full explanation of why this
# was needed on Windows specifically, unlike Lesson 16's Linux/macOS-oriented approach.
#
# Not committed to the repository (see .gitignore) -- run this once before `swift build`,
# the same way this repository's Java course documents downloading a JDBC driver JAR
# on demand rather than committing it.
set -euo pipefail
cd "$(dirname "$0")"

URL="https://sqlite.org/2024/sqlite-amalgamation-3450100.zip"
DEST="Sources/CSQLite3"

mkdir -p "$DEST/include"
echo "Downloading $URL ..."
rm -rf /tmp/sqlite-amalgamation-extract
curl -sL -o /tmp/sqlite-amalgamation.zip "$URL"
unzip -o -q /tmp/sqlite-amalgamation.zip -d /tmp/sqlite-amalgamation-extract
SRC_DIR="/tmp/sqlite-amalgamation-extract/sqlite-amalgamation-3450100"

cp "$SRC_DIR/sqlite3.c" "$DEST/sqlite3.c"
cp "$SRC_DIR/sqlite3.h" "$DEST/include/sqlite3.h"
rm -rf /tmp/sqlite-amalgamation.zip /tmp/sqlite-amalgamation-extract

echo "Done: $DEST/sqlite3.c and $DEST/include/sqlite3.h are ready. You can now run 'swift build'."
