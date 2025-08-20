import boto3
import os

glue = boto3.client('glue')

def lambda_handler(event, context):
    print("Received event:", event)

    # Extract bucket and key from event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key    = event['Records'][0]['s3']['object']['key']
    file_path = f"s3://{bucket}/{key}"

    print(f"Starting Glue job with SOURCE_PATH={file_path}")

    response = glue.start_job_run(
        JobName=os.environ['GLUE_JOB_NAME'],
        Arguments={
            '--SOURCE_PATH': file_path,
            '--TARGET_PATH': f"s3://{bucket}/transformed/"
        }
    )

    return {
        'statusCode': 200,
        'body': f"Glue job started: {response['JobRunId']}"
    }
