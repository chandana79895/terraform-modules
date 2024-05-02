environment = "dev"

#DynamoDB
billing_mode = "PAY_PER_REQUEST"
read_capacity = 5 
write_capacity  = 5 
hash_key = "id"
hash_key_type = "S"
secondary_key = "name"
secondary_key_type = "S"
aws_region = "us-east-1"

#opensearch
domain_name = "example-test"
engine_version = "OpenSearch_2.5"
instance_type = "t3.small.elasticsearch"
instance_count = "1"
domain_endpoint_options = "true"
ebs_volume_size = "10"
encrypt_at_rest_enabled = "true"
node_to_node_encryption_enabled = "true"
master_user_name = "admin"
master_user_password = "Test@1234"

#Lambda
run_time="python3.8"
handler="crudLambdaHandler.lambda_handler"
filename="crudLambdaHandler.py"

#API GATEWAY
type="REGIONAL"
path="example"
api_gateway_methods=["ANY"]
integration_type = "AWS_PROXY"


#Route53
domain_name = "example.com"
kubernetes_cluster_name = "k8s-monitor"
grafana_service_name = "grafana"
grafana_namespace = "prometheus"
