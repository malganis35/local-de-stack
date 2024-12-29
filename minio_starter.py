from minio import Minio
import io
import os

from dotenv import load_dotenv
load_dotenv()

# Minio connection details
MINIO_ENDPOINT = os.getenv('MINIO_ENDPOINT') # 'your-minio-endpoint'
MINIO_ACCESS_KEY = os.getenv('MINIO_ACCESS_KEY') # 'your-minio-access-key'
MINIO_SECRET_KEY = os.getenv('MINIO_SECRET_KEY') # 'your-minio-secret-key'

# Connect to Minio
minio = Minio(MINIO_ENDPOINT, MINIO_ACCESS_KEY, MINIO_SECRET_KEY, secure=False)

# Create a bucket
bucket_name = "bucket-keyrusds-test" # 'your-bucket-name'
if not minio.bucket_exists(bucket_name):
    minio.make_bucket(bucket_name)

# Insert a file
filename = 'example.txt'
file_content = b'Hello World!'
minio.put_object(bucket_name, filename, io.BytesIO(file_content), len(file_content))

# Retrieve the file
file = minio.get_object(bucket_name, filename)
print(file.read().decode('utf-8'))  