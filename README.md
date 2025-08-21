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

**See the screenshots section at the bottom of this README.**

## How to run the pipeline

### 1. Clone the Repository  
```bash
git clone https://github.com/luluna02/AWS-reddit-data-pipeline.git
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

## Screenshots

- DAG
  
<img width="1234" height="464" alt="Screenshot 2025-08-20 at 9 08 49 PM" src="https://github.com/user-attachments/assets/9f54064a-10bc-496f-821f-e8b5230d50aa" />

- S3
  
<img width="966" height="493" alt="Screenshot 2025-08-20 at 9 09 34 PM" src="https://github.com/user-attachments/assets/fca068f0-1e7a-48b2-b19c-b571cb0b81b6" />

- Glue
  
<img width="1239" height="526" alt="Screenshot 2025-08-20 at 9 10 12 PM" src="https://github.com/user-attachments/assets/2d71162b-bdb6-4b90-9041-8f98da26db88" />

- Lambda
  
<img width="1238" height="487" alt="Screenshot 2025-08-20 at 9 11 01 PM" src="https://github.com/user-attachments/assets/c08eb8c0-f337-41c8-bb6b-3545311e7706" />

- Redshift
  
<img width="1239" height="619" alt="Screenshot 2025-08-20 at 9 11 13 PM" src="https://github.com/user-attachments/assets/7e88956b-ef79-4d4f-a2cf-f534bcabff62" />





