#!/bin/bash
set -e

echo "Starting ERPNext installation..."

# Check if docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Load environment variables
source .env

# Start containers
echo "Starting containers..."
docker-compose up -d

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 30

# Create new site
echo "Creating new site..."
docker-compose exec erpnext-python bench new-site ${SITE_NAME} \
    --mariadb-root-password ${MYSQL_ROOT_PASSWORD} \
    --admin-password ${ADMIN_PASSWORD}

# Install ERPNext app
echo "Installing ERPNext application..."
docker-compose exec erpnext-python bench --site ${SITE_NAME} install-app erpnext

# Set site as default
echo "Setting site as default..."
docker-compose exec erpnext-python bench use ${SITE_NAME}

echo "Installation completed successfully!"
echo "You can now access ERPNext at http://localhost:${NGINX_PORT}"
echo "Login with:"
echo "Username: Administrator"
echo "Password: ${ADMIN_PASSWORD}"