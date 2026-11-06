Mobilify - DevOps CI/CD Project
Overview

Mobilify is a React-based e-commerce application deployed using a complete DevOps workflow. The project demonstrates Infrastructure as Code (Terraform), containerization with Docker, CI/CD automation using Jenkins Multibranch Pipelines, Docker Hub image management, and monitoring with Prometheus and Grafana.

Architecture
Developer
    │
    ▼
GitHub Repository
    │
    ├── dev branch
    │      ▼
    │   Jenkins Dev Pipeline
    │      ▼
    │   Docker Build
    │      ▼
    │   Docker Hub (dev repo)
    │
    └── Pull Request
           ▼
         main branch
           ▼
     Jenkins Prod Pipeline
           ▼
      Docker Hub (prod repo)
           ▼
      Docker Deployment
           ▼
      EC2 Instance

Tech Stack
AWS EC2 (Ubuntu)
Terraform
Docker
Docker Hub
Jenkins Multibranch Pipeline
GitHub Webhooks
Nginx
Prometheus
Node Exporter
Grafana
React Application
Infrastructure Provisioning
EC2 Instance Creation

Infrastructure is provisioned using Terraform.

Resources created:

AWS EC2 Instance (t2.micro)
Security Groups
Key Pair
Jenkins Installation
Docker Installation
Nginx Installation
Terraform Commands
terraform init

terraform validate

terraform plan

terraform apply

Application Containerization
Dockerfile
FROM nginx

COPY ./build/ /usr/share/nginx/html

EXPOSE 80

Build Docker Image
docker build -t mobilify .

Run Container
docker run -d -p 8081:80 mobilify

Docker Compose
docker-compose.yml
services:
  web:
    build: .
    container_name: react-con
    ports:
      - "8081:80"

Start Application
docker compose up -d

Verify Container
docker ps

Docker Hub Repositories
Development Repository
ragulgandhi/dev

Production Repository
ragulgandhi/prod

Jenkins Multibranch Pipeline
Branch Strategy
main
 └── Production

dev
 └── Development

Development Workflow
Push Code to Development Branch
git checkout dev

git add .

git commit -m "Feature Update"

git push origin dev

Jenkins Development Pipeline

The development pipeline:

Builds Docker image
Tags image using Jenkins Build Number
Pushes image to
ragulgandhi/dev:<build-number>


and

ragulgandhi/dev:latest

Production Workflow
Create Pull Request
dev → main

Merge Pull Request

Once merged:

GitHub Webhook triggers Jenkins
Production Pipeline starts automatically
Production Pipeline Tasks
Pull latest image from
ragulgandhi/dev:latest

Retag image
ragulgandhi/prod:<build-number>


Push image to production repository

Deploy container on EC2

Deployment Command
./scripts/deploy.sh ragulgandhi/prod <build-number> mob-prod 8081 80

GitHub Webhook Integration

GitHub webhook endpoint:

http://<jenkins-server>:8080/github-webhook/


Automatically triggers builds on:

Push to dev
Merge into main
Monitoring Stack
Prometheus

Installation:

wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz

tar -xvf prometheus-2.46.0.linux-amd64.tar.gz


Start Prometheus:

./prometheus --config.file=prometheus.yml


Default Port:

9090

Node Exporter

Installation:

wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz


Run:

./node_exporter


Default Port:

9100

Grafana

Installation:

sudo apt-get update

sudo apt-get install grafana


Start Service:

sudo systemctl start grafana-server

sudo systemctl enable grafana-server


Default Port:

3000

Monitoring Dashboard

Metrics collected:

CPU Utilization
Memory Usage
Disk Usage
Network Traffic
System Uptime
Load Average

Data Source:

Prometheus


Visualization:

Grafana Dashboard

Project Structure
Mobilify
│
├── Dockerfile
├── docker-compose.yml
├── Jenkinsfile
│
├── scripts
│   ├── build.sh
│   └── deploy.sh
│
├── build
│
└── terraform
    ├── provider.tf
    ├── resource.tf
    └── output.tf

CI/CD Flow
Developer Push
      │
      ▼
GitHub (dev)
      │
      ▼
Jenkins Dev Pipeline
      │
      ▼
Docker Hub (dev)
      │
      ▼
Pull Request
      │
      ▼
GitHub (main)
      │
      ▼
Jenkins Prod Pipeline
      │
      ▼
Docker Hub (prod)
      │
      ▼
Deploy to EC2
      │
      ▼
Production Application

Key Achievements

✅ Automated Infrastructure Provisioning using Terraform

✅ Dockerized React Application

✅ Jenkins Multibranch CI/CD Pipeline

✅ GitHub Webhook Integration

✅ Docker Hub Dev and Prod Repositories

✅ Automated Production Deployment

✅ Monitoring with Prometheus and Grafana

✅ AWS EC2 Hosting

Author

Ragul Gandhi

DevOps Project - Mobilify CI/CD Pipeline with Terraform, Jenkins, Docker, AWS, Prometheus and Grafana.
