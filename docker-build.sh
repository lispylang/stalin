#!/bin/bash
set -e

echo "Building Stalin Docker development environment..."

# Build the Docker image
docker build -t stalin-dev .

echo "Docker image built successfully!"
echo ""
echo "To run the development environment:"
echo "  docker run -it --rm -v \$(pwd):/stalin stalin-dev"
echo ""
echo "To build Stalin inside the container:"
echo "  docker run -it --rm -v \$(pwd):/stalin stalin-dev ./build"