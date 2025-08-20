from utils.constants import AWS_ACCESS_KEY_ID, AWS_ACCESS_KEY, AWS_BUCKET_NAME
from botocore.exceptions import ClientError
import botocore.session
import boto3
import os

def connect_to_s3():
    try:
        # Create a low-level session to avoid checksum issues
        session = boto3.Session(
            aws_access_key_id=AWS_ACCESS_KEY_ID,
            aws_secret_access_key=AWS_ACCESS_KEY
        )

        # Create S3 client with checksum disabled
        s3_client = session.client(
            's3',
            config=boto3.session.Config(
                s3={'addressing_style': 'path'},
                signature_version='s3v4'
            )
        )

        # Test connection with a simple operation
        s3_client.list_buckets()
        print("Connected to S3 successfully yeyyyy")
        return s3_client

    except Exception as e:
        print(f"Failed to connect to S3: {e}")
        return None


def create_bucket_if_not_exist(s3, bucket: str):
    try:
        # Check if bucket exists using head_bucket (more efficient)
        try:
            s3.head_bucket(Bucket=bucket)
            print("Bucket already exists")
        except ClientError as e:
            # If bucket doesn't exist, create it
            error_code = e.response['Error']['Code']
            if error_code == '404':
                s3.create_bucket(Bucket=bucket)
                print("Bucket created")
            else:
                print(f"Error checking bucket: {e}")
                raise
    except ClientError as e:
        print(f"Failed to check/create bucket: {e}")


def upload_to_s3(s3, file_path: str, bucket: str, s3_file_name: str):
    try:
        key = f"raw/{s3_file_name}"

        # Use a simpler upload approach without checksum
        with open(file_path, 'rb') as file_data:
            s3.put_object(
                Bucket=bucket,
                Key=key,
                Body=file_data
            )

        print(f"File uploaded to s3://{bucket}/{key}")
        return True

    except FileNotFoundError:
        print(f"The local file {file_path} was not found")
        return False
    except ClientError as e:
        print(f"Failed to upload to S3: {e}")
        return False
    except Exception as e:
        print(f"Unexpected error during upload: {e}")
        return False