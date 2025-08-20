# Event Driven ELT Pipeline on AWS for Reddit Data

This project implements a serverless, event-driven ELT data pipeline on AWS for collecting, transforming, and analyzing Reddit data. The pipeline leverages Lambda, S3, Glue, Redshift, Athena, Airflow, Docker, and Terraform to deliver a scalable and automated data processing workflow.

<img width="853" height="491" alt="Screenshot 2025-08-20 at 8 18 26 PM" src="https://github.com/user-attachments/assets/9d95c9a8-cb10-4c27-a606-b2f261af224e" />

## Architecture 

1. **Reddit Data Extraction** – Data ingested via Reddit API through Airflow dags for orchestration and stored in **S3 (Data Lake)**.  
2. **Event-Driven Processing** – S3 triggers a **Lambda function** when a file is uploaded in the raw data bucket, which invokes **Glue jobs**.  
3. **Transformation & Cataloging** – **AWS Glue** processes and catalogs data into the **Glue Data Catalog** and stores the transormed data in a transformed bucket.  
4. **Querying & Analytics** – Data accessible via **Athena** for ad-hoc queries and loaded into **Redshift** as the Data Warehouse.  
5. **Workflow Orchestration** – **Airflow** (running in Docker) schedules jobs and manages dependencies.  
6. **Infrastructure as Code** – **Terraform** provisions AWS resources.  
7. **CI/CD** – **GitHub Actions** automates deployments.  
8. **Metadata & Caching** – **PostgreSQL** stores Airflow metadata, **Redis** used for caching.

**Screenshots:  
- `images/s3-lambda.png` → S3 trigger to Lambda  
- `images/glue.png` → Glue job execution  
- `images/athena.png` → Athena query example  
- `images/redshift.png` → Redshift table after load  
- `images/airflow.png` → Airflow DAG view  


## How to run the pipeline

### 1. Clone the Repository  
```bash
git clone https://github.com/yourusername/reddit-aws-pipeline.git
cd reddit-aws-pipeline
```
### 2. Configure AWS CLI
Install AWS CLI and run:
```bash
aws configure
```
You will be prompted to enter:

- **AWS Access Key ID** → `your_access_key`
- **AWS Secret Access Key** → `your_secret_key`
- **Default region name** → `your-region`

### 3. Create `secrets.env` file
In the project root, create a secrets.env file for local development, This file is used by Docker and Airflow:
```bash
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_DEFAULT_REGION=us-east-1
```

### 4. Run Locally with Docker
Start Airflow & supporting services:
```bash
docker-compose up -d
```
Access Airflow UI:
```bash
http://localhost:8080
```

### 5. Deploy Infrastructure with Terraform
```bash
cd Infra-terraform
terraform init
terraform plan
terraform apply
```
This provisions S3, Lambda, Glue, IAM permissions etc.

### 6. Run Airflow DAG
In Airflow, either schedule the DAG or trigger it manually:

Ingests Reddit data → Stores in S3 → Triggers Glue through Lambda → Loads into Redshift → Queryable in Athena.






