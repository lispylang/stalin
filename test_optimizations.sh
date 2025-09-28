#!/bin/bash

echo "Optimization Level Comparison:"
echo "==============================="
for opt in 0 2 3 s; do
  echo "Building with -O$opt..."
  ./cosmocc/bin/cosmocc -O$opt -o bench-O$opt simple_benchmark.c
  if [ -f "bench-O$opt" ]; then
    size=$(ls -lh bench-O$opt | awk '{print $5}')
    echo "Size: $size"
    echo -n "Runtime: "
    time ./bench-O$opt >/dev/null
  fi
  echo "---"
done

echo ""
echo "Testing build modes:"
echo "===================="

# Test tiny mode
echo "Testing tiny mode..."
./cosmocc/bin/cosmocc -Os -mtiny -o bench-tiny simple_benchmark.c
if [ -f bench-tiny ]; then
  echo "Tiny mode size: $(ls -lh bench-tiny | awk '{print $5}')"
fi

# Test debug mode
echo "Testing debug mode..."
./cosmocc/bin/cosmocc -O0 -mdbg -g -o bench-debug simple_benchmark.c
if [ -f bench-debug ]; then
  echo "Debug mode size: $(ls -lh bench-debug | awk '{print $5}')"
fi

echo ""
echo "All tests completed!"