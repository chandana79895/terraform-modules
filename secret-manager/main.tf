
data "aws_secretsmanager_secret_version" "opensearch_credentials" {
  secret_id = "opensearch-credentials"
}

output "opensearch_username" {
  value = jsondecode(data.aws_secretsmanager_secret_version.opensearch_credentials.secret_string)["username"]
}

output "opensearch_password" {
  value = jsondecode(data.aws_secretsmanager_secret_version.opensearch_credentials.secret_string)["password"]
}

# Define OpenSearch endpoint
locals {
  opensearch_endpoint = "https://search-example-test-jaczkefowbxwkbft7j25ek4wyu.us-east-1.es.amazonaws.com/_dashboards"
}

# Authenticate with OpenSearch
data "http" "opensearch_auth" {
  url = "${local.opensearch_endpoint}/_security/_authenticate"
  method = "POST"
  headers = {
    "Content-Type" = "application/json"
  }
  body = jsonencode({
    "username": "${output.opensearch_username}",
    "password": "${output.opensearch_password}"
  })
}

# Output the authentication response
output "opensearch_auth_response" {
  value = jsondecode(data.http.opensearch_auth.body)
}