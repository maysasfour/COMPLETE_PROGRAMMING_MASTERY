# Pester tests. Written for Pester 3.4.0 syntax (the version confirmed installed live in
# this environment via 'Get-Module -ListAvailable Pester' - see 15-Modules's output).
# Pester 3.x uses 'Should Be' (no dash); Pester 4/5 use 'Should -Be'. If you have Pester 5+
# installed, either syntax generally still works, but this file targets what was verified here.

. "$PSScriptRoot\MathHelpers.ps1"

Describe "Get-Square" {
    It "squares a positive number" {
        Get-Square -Number 5 | Should Be 25
    }
    It "squares zero" {
        Get-Square -Number 0 | Should Be 0
    }
    It "squares a negative number" {
        Get-Square -Number -3 | Should Be 9
    }
}

Describe "Get-Average" {
    It "averages a normal set of numbers" {
        Get-Average -Numbers @(2,4,6) | Should Be 4
    }
    It "throws on an empty collection" {
        { Get-Average -Numbers @() } | Should Throw "Cannot average an empty collection."
    }
}
