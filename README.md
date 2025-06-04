# Yii2 PHP Application Deployment - DevOps Assessment

This project demonstrates an end-to-end deployment pipeline for a containerized Yii2 PHP application using Terraform, Ansible, Docker Swarm, GitHub Actions, and NGINX as a reverse proxy/load balancer.

---

## 📌 Project Overview

- **Application**: Sample Yii2 PHP application.
- **Infrastructure**: 
  - 2 EC2 instances provisioned as **application servers**.
  - 1 EC2 instance configured as a **reverse proxy/load balancer** running NGINX.
- **Orchestration**: Docker Swarm mode.
- **CI/CD**: GitHub Actions pipeline for automated deployment.
- **Automation**: Ansible playbooks for provisioning and configuration.

---

## 🧱 Infrastructure Setup

### 🚀 Provisioning with Terraform

- Terraform is used to provision:
  - Two EC2 instances for the application .
  - One EC2 instance for NGINX reverse proxy .
- Security groups and key pairs managed via Terraform.

---

## ⚙️ Application Deployment

### 🔧 Docker & Swarm

- The Yii2 PHP application is containerized using Docker.
- Docker Swarm is initialized on one application node and the second is joined as a worker.
- The application is deployed as a Docker Swarm service with replication across both app servers.

### 🌐 NGINX Load Balancing

- NGINX is installed on a separate EC2 instance **outside of Docker**.
- It acts as a reverse proxy and load balancer to both application servers on port `9000`.

Example NGINX upstream config:
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

http {
    upstream php_backend {
        server 54.86.84.41:9000;
        server 3.86.181.163:9000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://php_backend;
            proxy_http_version 1.1;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
GitHub Actions Workflow
Pipeline triggers on push to the main branch.

Steps:

Build Docker image of the Yii2 app.

Push image to Docker Hub .

SSH into the EC2 Application Servers.

Pull updated image and update the Docker service.

Playbooks Overview
Ansible automates the following tasks:

Install Docker and Docker Compose.

Install required PHP, NGINX, and Git packages.

Initialize Docker Swarm .

Clone Yii2 app repo to the EC2 instance .

Deploy the Yii2 app as a Docker Swarm service.

Configure NGINX with a reverse proxy pointing to app containers.

Access your Load Balancer EC2's public IP in a browser.

