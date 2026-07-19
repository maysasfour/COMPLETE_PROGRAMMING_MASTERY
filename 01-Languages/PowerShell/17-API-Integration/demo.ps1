# 17-API-Integration: Invoke-RestMethod (auto-parses JSON) vs. Invoke-WebRequest (raw response).
# Run live against jsonplaceholder.typicode.com - requires outbound internet access.

try {
    Write-Output "Invoke-RestMethod - automatically parses JSON into real PowerShell objects:"
    $post = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/posts/1" -Method Get
    Write-Output ("Type returned: " + $post.GetType().FullName)
    Write-Output ("post.title (direct property access, no manual JSON parsing): " + $post.title)
    Write-Output ("post.userId: " + $post.userId)

    Write-Output "`nInvoke-WebRequest - gives you the raw HTTP response (status, headers, raw Content string):"
    $resp = Invoke-WebRequest -Uri "https://jsonplaceholder.typicode.com/posts/1" -Method Get
    Write-Output ("StatusCode: " + $resp.StatusCode)
    Write-Output ("Content-Type header: " + $resp.Headers['Content-Type'])
    Write-Output ("Raw Content is a plain string - must be parsed manually: " + $resp.Content.Substring(0, 60) + "...")
    Write-Output ("Manually parsed via ConvertFrom-Json: " + (($resp.Content | ConvertFrom-Json).title))

    Write-Output "`nPOSTing JSON with Invoke-RestMethod:"
    $body = @{ title = "New Post"; body = "content"; userId = 1 } | ConvertTo-Json
    $created = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/posts" -Method Post -Body $body -ContentType "application/json"
    Write-Output ("Created post id (fake API echoes back an id): " + $created.id + "  title: " + $created.title)

    Write-Output "`nHandling a real HTTP error (404) with -ErrorAction Stop, catchable:"
    try {
        Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/posts/999999" -Method Get -ErrorAction Stop
    } catch {
        Write-Output ("Caught HTTP error: " + $_.Exception.Message)
    }
} catch {
    Write-Output "NETWORK UNAVAILABLE in this environment - could not reach jsonplaceholder.typicode.com."
    Write-Output ("Underlying error: " + $_.Exception.Message)
    Write-Output "The commands above are documented as written and are correct PowerShell 5.1 syntax;"
    Write-Output "re-run this script with internet access to see live captured output."
}
