# 11-Classes-and-OOP: PowerShell 5+'s real 'class' keyword, contrasted with the older
# PSCustomObject-based pseudo-OOP pattern that predates it.

Write-Output "The OLDER pattern (still common, pre-PS5): PSCustomObject + attached script method."
$oldStyleAccount = [PSCustomObject]@{ Owner = "Mays"; Balance = 100 }
$oldStyleAccount | Add-Member -MemberType ScriptMethod -Name Deposit -Value {
    param($amount) $this.Balance += $amount
}
$oldStyleAccount.Deposit(50)
Write-Output ("Old-style balance after deposit: " + $oldStyleAccount.Balance)
Write-Output "(No real type identity, no constructor, no enforced shape - just a bag of properties + attached script blocks.)"

Write-Output "`nThe REAL 'class' keyword (PowerShell 5.0+) - genuine .NET type behind it:"
class BankAccount {
    [string]$Owner
    [double]$Balance

    BankAccount([string]$owner, [double]$initialBalance) {
        $this.Owner = $owner
        $this.Balance = $initialBalance
    }

    [void]Deposit([double]$amount) {
        if ($amount -le 0) { throw "Deposit amount must be positive." }
        $this.Balance += $amount
    }

    [void]Withdraw([double]$amount) {
        if ($amount -gt $this.Balance) { throw "Insufficient funds." }
        $this.Balance -= $amount
    }

    [string]ToString() {
        return "{0}: `${1:N2}" -f $this.Owner, $this.Balance
    }
}

$account = [BankAccount]::new("Mays", 100)
$account.Deposit(50)
$account.Withdraw(30)
Write-Output ("Real class instance: " + $account.ToString())
Write-Output ("Real .NET type: " + $account.GetType().FullName)

Write-Output "`nInheritance is real too:"
class SavingsAccount : BankAccount {
    [double]$InterestRate

    SavingsAccount([string]$owner, [double]$initialBalance, [double]$rate) : base($owner, $initialBalance) {
        $this.InterestRate = $rate
    }

    [void]ApplyInterest() {
        $this.Balance += $this.Balance * $this.InterestRate
    }
}
$savings = [SavingsAccount]::new("Mays", 1000, 0.05)
$savings.ApplyInterest()
Write-Output ("Savings after interest: " + $savings.ToString())
Write-Output ("Is it also a BankAccount? " + ($savings -is [BankAccount]))

Write-Output "`nDeliberate error case - withdrawing more than the balance throws a real, catchable exception:"
try { $account.Withdraw(10000) } catch { Write-Output ("Caught: " + $_.Exception.Message) }
