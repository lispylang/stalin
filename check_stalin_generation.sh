#!/bin/bash
# Monitor Stalin generation progress

echo "🔍 Checking Stalin generation progress..."
echo "========================================"

# Check if container is running
if docker ps --format "table {{.Names}}" | grep -q "stalin-main-gen"; then
    echo "✅ Container is running"

    # Check CPU usage
    CPU=$(docker exec stalin-main-gen ps aux | grep stalin | grep -v grep | awk '{print $3}' | head -1)
    echo "📊 CPU usage: ${CPU}%"

    # Check if stalin.c exists
    if docker exec stalin-main-gen ls stalin.c >/dev/null 2>&1; then
        SIZE=$(docker exec stalin-main-gen ls -la stalin.c | awk '{print $5}')
        echo "📁 stalin.c exists: ${SIZE} bytes"

        # Check if generation is complete
        if docker logs stalin-main-gen 2>&1 | grep -q "STALIN_GENERATION_COMPLETE"; then
            echo "🎉 Stalin generation COMPLETE!"
            echo ""
            echo "📤 Extracting stalin-amd64.c..."
            docker cp stalin-main-gen:/stalin/stalin.c stalin-amd64.c
            docker rm -f stalin-main-gen

            if [ -f stalin-amd64.c ]; then
                LINES=$(wc -l < stalin-amd64.c)
                SIZE=$(ls -lh stalin-amd64.c | awk '{print $5}')
                echo "✅ stalin-amd64.c extracted: $LINES lines, $SIZE"
                echo ""
                echo "🔨 Ready to compile with:"
                echo "   gcc -o stalin-arm64 -I./include -O2 stalin-amd64.c -L./include -lm -lgc"
            else
                echo "❌ Failed to extract stalin-amd64.c"
            fi
        else
            echo "⏳ Still generating... (this can take 30-60 minutes)"
            echo "   Run this script again to check progress"
        fi
    else
        echo "⏳ stalin.c not yet created"
        echo "   Generation in progress..."
    fi

    # Show recent logs
    echo ""
    echo "📄 Recent activity:"
    docker logs stalin-main-gen 2>&1 | tail -5 | sed 's/^/   /'

else
    echo "❌ Container not running"
    echo "   Check docker ps -a to see if it exited"

    # Check for completed container
    if docker ps -a --format "table {{.Names}}\t{{.Status}}" | grep "stalin-main-gen" | grep -q "Exited"; then
        echo "   Container exited. Checking logs..."
        docker logs stalin-main-gen 2>&1 | tail -10
    fi
fi