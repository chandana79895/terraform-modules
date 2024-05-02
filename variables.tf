variable "environment" {
    description = "Environment variable"
}

#DynamoDB
variable "billing_mode" {}
variable "read_capacity" {}
variable "write_capacity"{}
variable "hash_key"{}
variable "hash_key_type"{}
variable "secondary_key"{}
variable "secondary_key_type"{}
variable "aws_region"{}

variable "domain_name"{}
variable "engine_version" {}
variable "instance_type"{}
variable "instance_count"{}
variable "domain_endpoint_options"{}
variable "node_to_node_encryption_enabled"{}
variable "encrypt_at_rest_enabled"{}
variable "ebs_volume_size"{}
variable "master_user_password"{}
variable "master_user_name"{}
variable "table_arn"{}

#lambda
variable "run_time"{}
variable "handler"{}
variable "filename"{}

# Api Gateway
variable "path"{}
variable "type"{}
variable "api_gateway_methods" {
  type = list(string)
}
variable "integration_type"{}

#Route53 
variable "domain_name"{}
variable "kubernetes_cluster_name"{}
variable "grafana_service_name"{}
variable "grafana_namespace"{}
