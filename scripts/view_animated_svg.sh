#!/bin/bash

# Script to generate and view the animated multi-page SVG

set -e

OUTPUT_DIR="output"
ANIMATED_FILE="$OUTPUT_DIR/animated_multipage.svg"

echo "🎬 Generating Animated Multi-Page SVG..."
echo "==============================================="

# Generate the animated SVG
echo "📋 Running test to generate animated SVG..."
scarb test test_output_animated_svg 2>&1 | sed -n "/=== ANIMATED SVG ===/,/=== END ANIMATED SVG ===/p" | sed '1d;$d' > "$ANIMATED_FILE"

if [ -s "$ANIMATED_FILE" ]; then
    echo "✅ Animated SVG generated successfully!"
    echo "📁 File: $ANIMATED_FILE"
    echo "📊 Size: $(ls -lh $ANIMATED_FILE | awk '{print $5}')"
    echo ""
    echo "🎨 Animation Features:"
    echo "  • 20-second cycle (5 seconds per page)"
    echo "  • Page 0: Inventory (Green theme)"
    echo "  • Page 1: Item Bag (Orange theme)" 
    echo "  • Page 2: Marketplace (Blue theme)"
    echo "  • Page 3: Battle (Red theme)"
    echo "  • Smooth opacity transitions"
    echo ""
    echo "💡 To view:"
    echo "  • Open with browser: open $ANIMATED_FILE"
    echo "  • Or double-click the file in file manager"
    echo ""
    echo "🎉 Generation complete!"
else
    echo "❌ Failed to generate animated SVG"
    exit 1
fi