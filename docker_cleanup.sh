#!/bin/bash

echo "Starting Docker cleanup..."

# 1. Remove unused images
echo "Removing unused Docker images..."
docker image prune -a -f

# 2. Remove dangling build cache (to reduce image size)
echo "Removing unused build cache..."
docker builder prune -f

# 3. Remove stopped containers (if any)
echo "Removing stopped Docker containers..."
docker container prune -f

# 4. Remove unused volumes
echo "Removing unused Docker volumes..."
docker volume prune -f

# 5. Show Docker disk usage after cleanup
echo "Disk usage after cleanup:"
docker system df

echo "Docker cleanup complete!"
