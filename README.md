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

## BuildBot Worker Containerization

BuildBot workers are deployed as Apptainer containers across all cluster nodes to ensure consistency and isolation. The deployment process installs Apptainer, distributes a pre-built container image (buildbot.sif), creates the necessary directory structure, initializes each worker with connection details to the BuildBot master, and manages the worker lifecycle (checking status and starting services as needed). The complete container deployment and configuration is automated through the Ansible playbook located at `roles/buildbot_worker/tasks/main.yml`

## Accessing the BuildBot Web Interface

To run the webserver (localhost:8010), please ssh with - ssh -L 127.0.0.1:8010:localhost:8010 {user@server}.
Then, connect to localhost on any browser on http://localhost:8010.

In this example, a worker was not initialized (by shutting down the node) to show how it is displayed in the web interface.

<img width="1596" height="104" alt="image" src="https://github.com/user-attachments/assets/f365a5b5-1495-4f4f-8739-49e80d89f5e9" />



`take_mac_addresses`

Captures network traffic using `tcpdump` to automatically discover and record MAC addresses of nodes during PXE boot. The script monitors DHCP requests for 800 seconds, filters for unique MAC addresses, and generates a JSON mapping file (`mac_address_database_ipmi.json`) linking each node identifier (l01-l28) to its corresponding MAC address for Cobbler provisioning.
