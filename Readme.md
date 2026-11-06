# Mobilify - End-to-End DevOps Pipeline & Infrastructure

Mobilify is a React-based e-commerce application deployed using modern DevOps practices. This repository contains the Infrastructure as Code (IaC) configuration using **Terraform**, containerization setup using **Docker** and **Docker Compose**, CI/CD multibranch pipeline automation using **Jenkins**, and a full monitoring stack using **Prometheus**, **Node Exporter**, and **Grafana**.

---

## 🛠 Tech Stack & Tools

* **Infrastructure as Code:** Terraform (AWS Provider `~> 5.0`)
* **Cloud Provider:** Amazon Web Services (AWS EC2 - `t2.micro`, Ubuntu)
* **Containerization:** Docker, Docker Compose, Nginx (Alpine)
* **CI/CD Automation:** Jenkins (Multibranch Pipeline)
* **Artifact Registry:** Docker Hub (`ragulgandhi/dev`, `ragulgandhi/prod`)
* **Monitoring & Observability:** Prometheus, Node Exporter, Grafana

---

## 📁 Repository Structure

```text
.
├── terraform/
│   ├── provider.tf        # AWS, TLS, and Local provider configurations
│   ├── resource.tf        # EC2 instance definition and remote-exec provisioners
│   └── output.tf          # Terraform output definitions (IPs, Instance ID, Keys)
├── scripts/
│   ├── build.sh           # Shell script to build and tag Docker images
│   └── deploy.sh          # Shell script for automated container deployment
├── Dockerfile             # Multi-stage/Nginx production image configuration
├── docker-compose.yml     # Container orchestration for local/dev environment
├── Jenkinsfile            # Declarative Multibranch Pipeline definition
└── README.md              # Project documentation
```

---

## 🚀 Key Features & Implementation Steps

### 1. Infrastructure Provisioning (Terraform)
* Provisioned an AWS EC2 instance (`t2.micro` running Ubuntu) dynamically within `ap-south-1`.
* Automated key pair creation via `hashicorp/tls` and saved standard PEM credentials locally.
* Configured `remote-exec` provisioners to automatically bootstrap system packages, including **Jenkins**, **OpenJDK 21**, **Docker**, and **Nginx**.

```bash
# Provision infrastructure
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### 2. Containerization & Local Development
* Built an optimized Nginx container serving static build assets for the React e-commerce application.
* Standardized deployment commands using Docker Compose mapping container port `80` to host port `8081`.

```bash
# Build and run locally with Docker Compose
docker-compose up -d --build
```

### 3. CI/CD Pipeline (Jenkins Multibranch)
The project utilizes a Jenkins Declarative Multibranch Pipeline with conditional execution based on Git branches:

* **`dev` Branch Pipeline:**
  1. Triggered on push to `dev`.
  2. Executes `./scripts/build.sh` to construct the Docker image tagged with build numbers and `latest`.
  3. Authenticates with Docker Hub using Jenkins credentials (`DH_PASS`).
  4. Pushes artifacts to `ragulgandhi/dev`.

* **`main` (Prod) Branch Pipeline:**
  1. Triggered on push or merge to `main`.
  2. Pulls verified images from `ragulgandhi/dev:latest`.
  3. Re-tags artifacts to `ragulgandhi/prod:<BUILD_NUMBER>` and `ragulgandhi/prod:latest`.
  4. Pushes artifacts to the production repository on Docker Hub (`ragulgandhi/prod`).
  5. Runs `./scripts/deploy.sh` to deploy the application on port `8081`.

### 4. Monitoring & Observability Stack

* **Prometheus:** Metrics collector installed on port `:9090`. Configured with `prometheus.yml` to target system and service endpoints.
* **Node Exporter:** Installed on port `:9100` to capture machine metrics (CPU utilization, memory usage, disk I/O, network traffic).
* **Grafana:** Visualized dashboard configured on port `:3000` with Prometheus integrated as the primary datasource for real-time monitoring.

---

## 📊 Endpoints & Verification

| Service | Port / URL | Description |
| :--- | :--- | :--- |
| **Mobilify Web App** | `http://<EC2_PUBLIC_IP>:8081` | React E-Commerce Frontend |
| **Jenkins UI** | `http://<EC2_PUBLIC_IP>:8080` | Build & Deployment Pipelines |
| **Prometheus** | `http://<EC2_PUBLIC_IP>:9090` | System & Service Metrics |
| **Node Exporter** | `http://<EC2_PUBLIC_IP>:9100` | Raw Host Metrics |
| **Grafana** | `http://<EC2_PUBLIC_IP>:3000` | System Dashboard & Metrics Visualization |

---

## 👤 Author
**Ragul Gandhi**  
* GitHub: [@Ragul-Gandhi](https://github.com/Ragul-Gandhi)  
* Docker Hub: [ragulgandhi](https://hub.docker.com/u/ragulgandhi)