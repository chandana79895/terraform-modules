
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
      master_user_name     = "admin"
      master_user_password = "Test@1234"
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

resource "aws_iam_policy" "example" {
  name = "osis_role_policy"
  description = "Policy for OSIS pipeline role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
          Action = "es:*",
          Effect = "Allow",
          Resource: "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        }
    ]
})
}

resource "aws_iam_role" "example" {
  name = "exampleosisrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "osis-pipelines.amazonaws.com"
        }
      },
    ]
  })
}