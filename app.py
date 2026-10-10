from flask import Flask
import json

def lambda_test(event, context):
    print("hello world - message from group Astra")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello world, from Astra!')
    }



app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, Alex Ong!</p>"

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)