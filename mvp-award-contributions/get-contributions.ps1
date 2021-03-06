#
# Authenticate
# One way to acquire the bearer token is to use the Microsoft MVP API Try It GUI.
# 1. Go to https://mvpapi.portal.azure-api.net/Products > MVP Production > MVP Production > GetContributions > Try It.
# 2. Then set Authorization drop down list to Authorization Code.
# 3. Then copy the resultant Authorizatio header from the UI.
# 
# Another way would be 
#

$subscriptionKey = $env:MVP_SUBSCRIPTION_KEY;
$bearerToken = $env:MVP_BEARER_TOKEN;

if (($subscriptionKey -eq $null) -or ($bearerToken -eq $null)) {
    Write-Output "Please set the MVP_SUBSCRIPTION_KEY and MVP_BEARER_TOKEN environmental variables.";
    exit;
}

#
# Set some reasonable constant values.
# E.g. Assume the award cycle is from April 01 to March 31.
#

$cycleStartDate = "2017-04-01"; 
$offset = 0;
$limit = 500;

#
# Fetch the contributions.
#

$headers = @{};
$headers["Ocp-Apim-Subscription-Key"] = $subscriptionKey;
$headers["Authorization"] = "Bearer $bearerToken";

$response = Invoke-WebRequest -UseBasicParsing "https://mvpapi.azure-api.net/mvp/api/contributions/$offset/$limit" -Headers $headers
$global:contributions = $response | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty Contributions

#
# Filter the contributions.
#

$filtered = $global:contributions | Where-Object { (Get-Date $_.StartDate ) -gt (Get-Date $cycleStartDate) }

#
# Make the contributions kind of prettier.
#

$pretty = $filtered | Select-Object ContributionTypeName, Title, Description, ReferenceUrl, AnnualQuantity, AnnualReach, StartDate | Format-List

#
# Write to file
#

$outfile = "output.txt";
$pretty | Out-File $outfile -Encoding utf8
Write-Output "Open $outfile for the results."


