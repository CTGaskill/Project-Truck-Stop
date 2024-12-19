# Reddit credentials (replace with your own values)
$clientId = "your_client_id"
$clientSecret = "your_client_secret"
$userAgent = "your_user_agent"
$redditUser = "reddit_username"  # The Reddit username whose comments you want to retrieve
$limit = 5  # Limit the number of comments to fetch

# Get the Reddit API access token
$authUrl = "https://www.reddit.com/api/v1/access_token"
$base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$clientId:$clientSecret"))

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

# Define the URL for the user's comments
$commentsUrl = "https://oauth.reddit.com/user/$redditUser/comments"

# Get the comments
$comments = Invoke-RestMethod -Uri $commentsUrl -Method Get -Headers $headers -Body $null

# Output the first $limit comments
$comments.data.children | Select-Object -First $limit | ForEach-Object {
    $comment = $_.data
    Write-Host "Comment ID: $($comment.id)"
    Write-Host "Subreddit: $($comment.subreddit)"
    Write-Host "Comment: $($comment.body)"
    Write-Host "----------------------------------------"
}
