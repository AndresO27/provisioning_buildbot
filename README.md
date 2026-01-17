# Cluster Provisioning for CI/CD Testing

This repository provides automated provisioning and deployment for a 28-node test cluster, designed for continuous integration and large-scale testing workflows.

## Overview

The infrastructure uses automation tools to create a reproducible and scalable testing environment:

- **Cobbler** – Bare-metal provisioning and operating system deployment  
- **Ansible** – Configuration management and orchestration  
- **Buildbot** – CI/CD automation (containerized deployment)

## Key Features

- Fully automated provisioning of 28 physical nodes  
- Containerized Buildbot deployment for consistency and portability  
- Infrastructure-as-code approach for reproducible environments  
- Designed for large-scale integration testing and build automation  

## Architecture

The cluster uses Cobbler for initial bare-metal provisioning, followed by Ansible playbooks for system configuration and service deployment. Buildbot runs in containers to ensure consistent behavior across environments and to simplify upgrades and maintenance.
