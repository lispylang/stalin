#!/bin/bash
set -e

echo "Testing Stalin compilation in Docker..."

# Build a test image that includes our source
docker build -t stalin-test -f- . <<'EOF'
FROM stalin-dev
WORKDIR /stalin
COPY . .
RUN chmod +x build-modern test-docker.sh
CMD ["./test-docker.sh"]
EOF

echo "Running Stalin test in Docker..."
docker run --rm stalin-test