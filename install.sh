#!/bin/bash
docker-compose up -d
sleep 30

# Create new site
docker-compose exec erpnext-python bench new-site erp.local \
    --mariadb-root-password 123 \
    --admin-password admin

# Install ERPNext app
docker-compose exec erpnext-python bench --site erp.local install-app erpnext

# Set site as default
docker-compose exec erpnext-python bench use erp.local 