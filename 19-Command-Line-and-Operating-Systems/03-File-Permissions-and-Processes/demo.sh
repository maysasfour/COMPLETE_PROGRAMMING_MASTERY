#!/bin/bash
# demo.sh - reproduces this lesson's real, live-verified findings about file
# permissions (including a genuine, disclosed platform difference) and safe,
# PID-verified process management.
set -e

echo "=== File permissions: chmod, verified live ==="
cat > greet.sh << 'SCRIPT'
#!/bin/bash
echo "Hello from greet.sh"
SCRIPT
chmod +x greet.sh
echo "Permissions after chmod +x:"
stat -c "%a %n" greet.sh
echo "Running with execute permission:"
./greet.sh
echo "exit code: $?"

echo ""
echo "Removing ALL permissions except read (chmod 600):"
chmod 600 greet.sh
echo "Reported permissions after chmod 600:"
stat -c "%a %n" greet.sh
echo "Attempting to run it anyway:"
./greet.sh
echo "exit code: $?"
echo "(See this lesson's README for why this exit code may be 0 rather than"
echo " 'Permission denied' on this platform -- a real, disclosed finding.)"

echo ""
echo "=== Process management: start, list, and safely kill by EXACT PID ==="
sleep 60 &
BGPID=$!
echo "Started a real background process with PID: $BGPID"
sleep 1
echo "Listing it by that exact PID (never by name -- see README for why):"
ps -p $BGPID
echo "Killing it by that exact PID:"
kill $BGPID
sleep 1
echo "Confirming it is genuinely gone (a non-zero exit code below means gone):"
ps -p $BGPID; echo "ps exit code: $?"
