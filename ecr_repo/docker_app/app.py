import os
import json
import boto3
from PIL import Image
from io import BytesIO

sqs = boto3.client("sqs", region_name=os.getenv("AWS_REGION"))
s3 = boto3.client("s3", region_name=os.getenv("AWS_REGION"))

QUEUE_URL = os.getenv("SQS_QUEUE_URL")
SOURCE_BUCKET = os.getenv("SOURCE_BUCKET")
DEST_BUCKET = os.getenv("DESTINATION_BUCKET")


def poll_sqs():
    messages = sqs.receive_message(
        QueueUrl=QUEUE_URL,
        MaxNumberOfMessages=1,
        WaitTimeSeconds=10,
    ).get("Messages", [])

    for message in messages:
        try:
            body = json.loads(message["Body"])
            record = json.loads(body["Message"])["Records"][0]

            key = record["s3"]["object"]["key"]

            print(f"Processing object: {key}")

            convert_image(key)

            # Delete the message from the queue
            sqs.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=message["ReceiptHandle"])
        except Exception as e:
            print(f"Error processing message: {e}")


def convert_image(key):
    # Download image from source bucket
    obj = s3.get_object(Bucket=SOURCE_BUCKET, Key=key)
    img = Image.open(BytesIO(obj["Body"].read()))

    # Convert to PNG
    new_key = os.path.splitext(key)[0] + ".png"
    buffer = BytesIO()
    img.save(buffer, format="PNG")
    buffer.seek(0)

    # Upload to destination bucket
    s3.put_object(Bucket=DEST_BUCKET, Key=new_key, Body=buffer)
    print(f"Converted and uploaded to: {new_key}")


if __name__ == "__main__":
    while True:
        poll_sqs()
