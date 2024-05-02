provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    region = "us-east-1"
  }
}

data "archive_file" "handler_zip" {
  type        = "zip"
  source_file = "${path.module}/${var.filename}"
  output_path = "${path.module}/handler.zip"
}

module "opensearch" {
  source = "./opensearch"
  domain_name                = var.domain_name
  engine_version      = var.engine_version
  instance_type              = var.instance_type
  instance_count             = var.instance_count
  ebs_volume_size            = var.ebs_volume_size
  encrypt_at_rest_enabled = var.encrypt_at_rest_enabled
  node_to_node_encryption_enabled = var.node_to_node_encryption_enabled
  domain_endpoint_options = var.domain_endpoint_options
  master_user_name = var.master_user_name
  master_user_password = var.master_user_password
  table_arn = module.dynamodb.dynamodb_arn 
} 

module "dynamodb" {
  source = "./dynamodb"
  billing_mode = var.billing_mode
  read_capacity = var.read_capacity
  write_capacity  = var.write_capacity 
  hash_key = var.hash_key
  hash_key_type = var.hash_key_type
  secondary_key = var.secondary_key
  secondary_key_type = var.secondary_key_type
  dynamodb_environment = var.environment
  aws_region = var.aws_region
}

#Lambda
module "lambda" {
    source = "./lambda"
    handler = var.handler
    run_time = var.run_time
    file_path = data.archive_file.handler_zip.output_path
    dynamodb_created_table = module.dynamodb.dynamodb_created_table
    lambda_environment = var.environment
}
#Api Gateway
module "api_gateway"{
    source = "./api_gateway"
    integration_type = var.integration_type
    path = var.path
    type = var.type
    api_gateway_methods = var.api_gateway_methods
    stage_name = var.environment
    function_name = module.lambda.created_lambda_function_name
    function_arn = module.lambda.created_lambda_function_arn
    api_gateway_environment = var.environment
}

#Cluster
module "cluster"{
  source= "./cluster"
}


