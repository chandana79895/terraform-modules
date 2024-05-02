variable "aws_region" {
  description = "The AWS region where the Route53 domain will be created."
  default     = "us-east-1"  # Change this to your desired region
}

variable "domain_name" {
  description = "The domain name you want to use for hosting Grafana."
  type        = string
}

variable "kubernetes_cluster_name" {
  description = "The name of your Kubernetes cluster."
  type        = string
}

variable "grafana_service_name" {
  description = "The name of the Grafana service in Kubernetes."
  type        = string
}

variable "grafana_namespace" {
  description = "The namespace where Grafana is deployed in Kubernetes."
  type        = string
}
