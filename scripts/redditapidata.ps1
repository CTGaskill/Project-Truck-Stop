Function Convert-FromUnixDate ($UnixDate) {
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($UnixDate))
 }


# Reddit credentials
$clientId = $env:REDDIT_USER
$clientSecret = $env:REDDIT_PASSWORD
$userAgent = "Web Scraper bot by /u/Available-Pickle-299"
$redditUser = "Strong_Voice8670" 
$commentlimit = 1000

# Get the Reddit API access token
$authUrl = "https://www.reddit.com/api/v1/access_token"
$base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${clientId}:${clientSecret}"))

# Set up the request headers for authentication
$headers = @{
    "Authorization" = "Basic $base64Auth"
    "User-Agent" = $userAgent
}

# Set up the body to request an access token
$body = @{
    "grant_type" = "client_credentials"
}

# Get the access token
$response = Invoke-RestMethod -Uri $authUrl -Method Post -Headers $headers -Body $body
$accessToken = $response.access_token

# Set up the headers with the access token for subsequent API requests
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "User-Agent" = $userAgent
}

###BUNCH of copypaste go back and modularize

$commentsUrl =@( "https://oauth.reddit.com/user/$redditUser/comments",
"https://oauth.reddit.com/user/$redditUser/?count=25&after=t1_lydac40",
"https://oauth.reddit.com/user/$redditUser/?count=50&after=t1_lri4oyr",
"https://oauth.reddit.com/user/$redditUser/?count=75&after=t1_lpgeswn",
"https://oauth.reddit.com/user/$redditUser/?count=100&after=t1_loafb02",
"https://oauth.reddit.com/user/$redditUser/?count=125&after=t1_lmvi0d6",
"https://oauth.reddit.com/user/$redditUser/?count=150&after=t1_llr9pud",
"https://oauth.reddit.com/user/$redditUser/?count=175&after=t1_lj00nii",
"https://oauth.reddit.com/user/$redditUser/?count=200&after=t1_lgv3uzk",
"https://oauth.reddit.com/user/$redditUser/?count=225&after=t1_lel4x8b",
"https://oauth.reddit.com/user/$redditUser/?count=250&after=t1_l8gl70w",
"https://oauth.reddit.com/user/$redditUser/?count=275&after=t1_l6mr782",
"https://oauth.reddit.com/user/$redditUser/?count=300&after=t1_l4x7w2v",
"https://oauth.reddit.com/user/$redditUser/?count=325&after=t1_l41ewmo",
"https://oauth.reddit.com/user/$redditUser/?count=350&after=t1_l3fct3r",
"https://oauth.reddit.com/user/$redditUser/?count=375&after=t1_l1it2cb",
"https://oauth.reddit.com/user/$redditUser/?count=400&after=t1_l03rwy9",
"https://oauth.reddit.com/user/$redditUser/?count=425&after=t1_kwhjric",
"https://oauth.reddit.com/user/$redditUser/?count=450&after=t1_ku51t7z",
"https://oauth.reddit.com/user/$redditUser/?count=475&after=t1_ks7yz9h",
"https://oauth.reddit.com/user/$redditUser/?count=500&after=t1_krlh2af",
"https://oauth.reddit.com/user/$redditUser/?count=525&after=t1_kpvjhvf",
"https://oauth.reddit.com/user/$redditUser/?count=550&after=t1_kpg34gi",
"https://oauth.reddit.com/user/$redditUser/?count=575&after=t1_kowpdsc",
"https://oauth.reddit.com/user/$redditUser/?count=600&after=t1_kos8eov",
"https://oauth.reddit.com/user/$redditUser/?count=625&after=t1_kjfw8mm",
"https://oauth.reddit.com/user/$redditUser/?count=650&after=t1_khpo514",
"https://oauth.reddit.com/user/$redditUser/?count=675&after=t1_kh4lv6a",
"https://oauth.reddit.com/user/$redditUser/?count=700&after=t1_kfrhe8p",
"https://oauth.reddit.com/user/$redditUser/?count=725&after=t1_kelnpo3")

# Get the comments

$string = foreach ($url in $commentsUrl) {
    [string]$url
}

$comments = ForEach ($url in $string) {
    Invoke-RestMethod -Uri $url -Method Get -Headers $headers -Body $null
}

new-item data.csv

# Output the first $limit comments
$comments.data.children | Select-Object -First $commentlimit | ForEach-Object {
    $comment = $_.data
    $nicetime = Convert-FromUnixDate $comment.created

    Write-Host "Comment ID: $($comment.id)" 
    Write-Host "Subreddit: $($comment.subreddit)"
    Write-Host "Comment: $($comment.body)"
    Write-Host "Created: $nicetime"
    Write-Host "----------------------------------------"

    $csvdata =[pscustomobject]@{
        'datetime' = $nicetime
        'Subreddit' = $comment.subreddit
        'Comment' = $comment.body -replace('[^\u0000-\u007F]', '')
        'IsNSFW?' = $comment.over_18
        'CommentID' = $comment.id
    }

    $csvdata | Export-CSV .\data.csv -Append -NoTypeInformation -Force -Encoding UTF8

}