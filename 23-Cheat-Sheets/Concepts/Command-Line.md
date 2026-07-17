# Command Line Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../19-Command-Line-and-Operating-Systems/README.md)

## Bash Essentials
```bash
for file in dir/*.txt; do echo "$file"; done   # glob directly -- never parse `ls`
echo "line" > file.txt      # overwrite
echo "line" >> file.txt     # append
command1 | command2          # pipe
grep -c "pattern" file.txt   # count matches
```
`for file in $(ls dir)` word-splits on spaces in filenames — verified live to turn 2 real files into 4 wrong pieces. Always quote expansions and prefer globbing. See [19-Command-Line-and-Operating-Systems/01](../../19-Command-Line-and-Operating-Systems/01-Bash-Basics/README.md).

## PowerShell Essentials
```powershell
Get-ChildItem | Where-Object { $_.Length -gt 100 } | Sort-Object Length -Descending
"Hello" -eq "hello"    # True  -- case-INSENSITIVE by default!
"Hello" -ceq "hello"   # False -- explicit case-sensitive
```
PowerShell pipes real objects, not text — filter/sort by real properties. `-eq` is case-insensitive by default, a real, verified authorization-bug risk. See [19-Command-Line-and-Operating-Systems/02](../../19-Command-Line-and-Operating-Systems/02-PowerShell-Basics/README.md).

## File Permissions and Processes
```bash
chmod +x script.sh       # add execute permission
chmod 600 file.txt        # owner read/write only
ps -p $PID                # check if a process is running
kill $PID                  # terminate by EXACT pid -- never by name
```
`chmod`'s enforcement is filesystem-dependent — verified live that it did not restrict execution on this session's Windows/NTFS + Git Bash setup, unlike native Linux. Always target an exact PID, never a process name, when killing processes. See [19-Command-Line-and-Operating-Systems/03](../../19-Command-Line-and-Operating-Systems/03-File-Permissions-and-Processes/README.md).

See the [full Command Line module](../../19-Command-Line-and-Operating-Systems/README.md) for real, captured terminal output for everything above.
