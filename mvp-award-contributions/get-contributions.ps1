
#
# One alternative is to use the same bearer token that the Microsoft MVP API uses in its Try It user interface.
# 1. Go to https://mvpapi.portal.azure-api.net/Products/ > MVP Production > MVP Production > GetContributions > Try It
# Then set Authorization to Authorization Code.
# Then copy the resultant Authorizatio header from the UI.
#

$subscriptionKey = $env:MVP_SUBSCRIPTION_KEY;
$bearerToken = $env:MVP_BEARER_TOKEN;

#
# Assume the award cycle is from April 01 to March 31.
#
$currentCycleStartDate = "2017-04-01"; 

if (($subscriptionKey -eq $null) -or ($bearerToken -eq $null)) {
    Write-Output "Please set the MVP_SUBSCRIPTION_KEY and MVP_BEARER_TOKEN environmental variables.";
    exit;
}

$offset = 0;
$limit = 100;

$headers = @{};
$headers["Ocp-Apim-Subscription-Key"] = $subscriptionKey;
$headers["Authorization"] = "Bearer $bearerToken";

$response = Invoke-WebRequest -UseBasicParsing "https://mvpapi.azure-api.net/mvp/api/contributions/$offset/$limit" -Headers $headers

$contributions = $response | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty Contributions

$currentCycleContributions = $contributions | Where-Object { (Get-Date $_.StartDate ) -gt (Get-Date "2017-03-31") }

