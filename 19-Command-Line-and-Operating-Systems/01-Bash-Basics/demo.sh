#!/bin/bash
# demo.sh - run this in an empty, throwaway directory to reproduce every real
# command and output shown in this lesson's README, including a genuine,
# reproducible word-splitting bug and its fix.
set -e

mkdir -p reports
touch "reports/January Sales.txt" "reports/February Sales.txt"
echo "--- Files actually created (note the SPACES in the real filenames) ---"
ls -la reports/

echo ""
echo "--- Violation: unquoted \$(ls ...) in a for loop -- word-splits on spaces ---"
count=0
for file in $(ls reports); do
    count=$((count+1))
    echo "  Processing piece: '$file'"
done
echo "ls reports/*.txt found 2 real files, but the loop processed $count pieces"

echo ""
echo "--- Fixed: glob directly, no ls parsing, no word-splitting ---"
count=0
for file in reports/*.txt; do
    count=$((count+1))
    echo "  Processing file: '$file'"
done
echo "Correctly processed $count real files"

echo ""
echo "--- Pipes and redirection, verified with real files ---"
echo "line one" > output.txt
echo "line two" >> output.txt
echo "line three" >> output.txt
echo "Real file content after > then >> >>:"
cat output.txt
echo "Piping through grep + wc -l (real counted matches):"
grep -c "line" output.txt
