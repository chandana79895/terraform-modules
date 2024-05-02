provider "http" {
}

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
  opensearch_endpoint = ""
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


data "aws_region" "current" {}
 
data "aws_caller_identity" "current" {}

resource "aws_opensearch_domain" "example" {
  domain_name    = var.domain_name
  engine_version = "OpenSearch_2.5"


  cluster_config {
    instance_type = "t3.small.search"
    instance_count = "1"
  }

  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "var.master_user_name"
      master_user_password = "var.master_user_password"
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  node_to_node_encryption {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": {
              "AWS": "*"
            },
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
           
        }
    ]
}
CONFIG
}
