output "created_lambda_function_name"{
    value = aws_lambda_function.lambda_for_api.function_name

}

output "created_lambda_function_arn"{
    value = aws_lambda_function.lambda_for_api.invoke_arn
}