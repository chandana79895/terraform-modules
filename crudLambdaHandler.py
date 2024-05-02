import json
import boto3
import os 
import logging

# Initialize you log configuration using the base class
logging.basicConfig(level = logging.INFO)

# Retrieve the logger instance
logger = logging.getLogger()

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    http_method = event['httpMethod']
    path = event['path']

    if path == '/example':
        if http_method == 'GET':
            response = table.scan()
            items = response['Items']
            return {
                'statusCode': 200,
                'body': json.dumps(items)
            }
        elif http_method == 'POST':
            logger.info(event)
            
            # json_data = json.dumps(event['body'])
            json_data = event['body']
            data = json.loads(json_data)

            item = {
                'id': data['id'],
                'name': data['name']
            }
            table.put_item(Item=item)
            return {
                'statusCode': 201,
                'body': json.dumps(item)
            }
        elif http_method == 'PUT':
            # json_data = json.dumps(event['body'])
            json_data = event['body']
            data = json.loads(json_data)
            item = {
                'id': data['id'],
                'name': data['name']
            }
            table.put_item(Item=item)
            return {
                'statusCode': 200,
                'body': json.dumps(item)
            }
        elif http_method == 'DELETE':
            # json_data = json.dumps(event['body'])
            json_data = event['body']
            data = json.loads(json_data)
            id = data['id']
            table.delete_item(Key={'id': id})
            return {
                'statusCode': 204
            }
        else:
            return {
                'statusCode': 405
            }
    else:
        return {
            'statusCode': 404
        }