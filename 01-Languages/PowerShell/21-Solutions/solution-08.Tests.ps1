# Solution 8 - Pester coverage for the Book class (see 20-Exercises/README.md, problem 8).
# Dot-sources solution-04.ps1 to reuse the exact Book class from exercise 4 rather than
# redefining it - the [Book] class definition itself is skipped from re-running its own
# demo code because solution-04.ps1 guards that block with $MyInvocation.InvocationName.
. "$PSScriptRoot\solution-04.ps1"

Describe "Book" {

    It "starts not checked out" {
        $book = [Book]::new("1984", "George Orwell")
        $book.IsCheckedOut | Should Be $false
    }

    It "can be checked out" {
        $book = [Book]::new("1984", "George Orwell")
        $book.CheckOut()
        $book.IsCheckedOut | Should Be $true
    }

    It "throws when checking out an already-checked-out book" {
        $book = [Book]::new("1984", "George Orwell")
        $book.CheckOut()
        { $book.CheckOut() } | Should Throw "is already checked out"
    }

    It "can be returned after being checked out" {
        $book = [Book]::new("1984", "George Orwell")
        $book.CheckOut()
        $book.ReturnBook()
        $book.IsCheckedOut | Should Be $false
    }

    It "throws when returning a book that was never checked out" {
        $book = [Book]::new("1984", "George Orwell")
        { $book.ReturnBook() } | Should Throw "was not checked out"
    }
}
