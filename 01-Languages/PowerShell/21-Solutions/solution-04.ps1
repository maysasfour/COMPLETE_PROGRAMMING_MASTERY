# Solution 4 - A real class: Book (see 20-Exercises/README.md, problem 4).
# Defined at script scope (not inside a function) so 21-Solutions/solution-08.Tests.ps1
# can dot-source this exact file and reuse the class for Pester coverage (exercise 8).
#
# GOTCHA (found and fixed while building this solution): a first draft named the second
# method 'Return()' - PowerShell classes genuinely fail to parse that as a method name at
# all, because 'Return' is a reserved language keyword. Verified live with a minimal
# repro (a throwaway class with just a '[void]Return(){}' method) which produced a real
# parser error: "Missing a property name or method definition" / "Missing closing '}' in
# statement block or type definition" - not a runtime error, a parse-time failure that
# stops the whole script from loading. Fixed by naming it ReturnBook() instead.
class Book {
    [string]$Title
    [string]$Author
    [bool]$IsCheckedOut = $false

    Book([string]$title, [string]$author) {
        $this.Title = $title
        $this.Author = $author
    }

    [void]CheckOut() {
        if ($this.IsCheckedOut) { throw "'$($this.Title)' is already checked out." }
        $this.IsCheckedOut = $true
    }

    [void]ReturnBook() {
        if (-not $this.IsCheckedOut) { throw "'$($this.Title)' was not checked out." }
        $this.IsCheckedOut = $false
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    $book = [Book]::new("Dune", "Frank Herbert")
    $book.CheckOut()
    Write-Output "Checked out: $($book.Title), IsCheckedOut=$($book.IsCheckedOut)"
    try { $book.CheckOut() } catch { Write-Output "Caught: $($_.Exception.Message)" }
    $book.ReturnBook()
    Write-Output "Returned: IsCheckedOut=$($book.IsCheckedOut)"
    try { $book.ReturnBook() } catch { Write-Output "Caught: $($_.Exception.Message)" }
}
