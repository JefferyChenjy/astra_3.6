import json, flask

def lambda_test(event, context):
    print("hello world - message from group Astra")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello world, from Astra!')
    }
