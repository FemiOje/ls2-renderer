#!/bin/bash

# Script to generate and view animated SVG for different states

set -e

OUTPUT_DIR="output"
NORMAL_FILE="$OUTPUT_DIR/animated_normal_mode.svg"
BATTLE_FILE="$OUTPUT_DIR/animated_battle_mode.svg"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🎬 Generating Animated SVGs for Different States..."
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to generate normal mode SVG
generate_normal_mode() {
    echo -e "${BLUE}📋 Generating Normal Mode SVG...${NC}"
    scarb test test_output_dynamic_animated_svg_comparison 2>&1 | sed -n "/=== NORMAL MODE SVG ===/,/=== END NORMAL MODE SVG ===/p" | sed '1d;$d' > "$NORMAL_FILE"
    
    if [ -s "$NORMAL_FILE" ]; then
        echo -e "${GREEN}✅ Normal Mode SVG generated successfully!${NC}"
        echo "📁 File: $NORMAL_FILE"
        echo "📊 Size: $(ls -lh $NORMAL_FILE | awk '{print $5}')"
        echo ""
        echo -e "${GREEN}🎨 Normal Mode Features:${NC}"
        echo "  • 10-second cycle (5 seconds per page)"
        echo "  • Page 0: Inventory (Green theme - #78E846)"
        echo "  • Page 1: Item Bag (Orange theme - #E89446)"
        echo "  • Smooth opacity transitions between pages"
        echo "  • Active when adventurer is NOT in battle"
        return 0
    else
        echo -e "${RED}❌ Failed to generate Normal Mode SVG${NC}"
        return 1
    fi
}

# Function to generate battle mode SVG
generate_battle_mode() {
    echo ""
    echo -e "${BLUE}📋 Generating Battle Mode SVG...${NC}"
    scarb test test_output_dynamic_animated_svg_comparison 2>&1 | sed -n "/=== BATTLE MODE SVG ===/,/=== END BATTLE MODE SVG ===/p" | sed '1d;$d' > "$BATTLE_FILE"
    
    if [ -s "$BATTLE_FILE" ]; then
        echo -e "${GREEN}✅ Battle Mode SVG generated successfully!${NC}"
        echo "📁 File: $BATTLE_FILE"
        echo "📊 Size: $(ls -lh $BATTLE_FILE | awk '{print $5}')"
        echo ""
        echo -e "${RED}⚔️  Battle Mode Features:${NC}"
        echo "  • Static display (no animation)"
        echo "  • Page 2: Battle page only (Red theme - #FF6B6B)"
        echo "  • Shows current battle interface"
        echo "  • Active when adventurer is IN battle (beast_health > 0)"
        return 0
    else
        echo -e "${RED}❌ Failed to generate Battle Mode SVG${NC}"
        return 1
    fi
}

# Generate both modes
normal_success=0
battle_success=0

if generate_normal_mode; then
    normal_success=1
fi

if generate_battle_mode; then
    battle_success=1
fi

echo ""
echo "=================================================="
echo -e "${BLUE}📊 Generation Summary:${NC}"
echo ""

if [ $normal_success -eq 1 ]; then
    echo -e "${GREEN}✓ Normal Mode SVG:${NC} $NORMAL_FILE"
else
    echo -e "${RED}✗ Normal Mode SVG: Failed${NC}"
fi

if [ $battle_success -eq 1 ]; then
    echo -e "${GREEN}✓ Battle Mode SVG:${NC} $BATTLE_FILE"  
else
    echo -e "${RED}✗ Battle Mode SVG: Failed${NC}"
fi

echo ""
echo -e "${BLUE}💡 To view the SVGs:${NC}"
echo "  • Open with browser: open $OUTPUT_DIR/*.svg"
echo "  • Or double-click the files in file manager"
echo ""
echo -e "${BLUE}🎮 State Differences:${NC}"
echo "  • Normal Mode: 2-page animated cycle (inventory + item bag)"
echo "  • Battle Mode: Single static battle page only"
echo ""

if [ $normal_success -eq 1 ] && [ $battle_success -eq 1 ]; then
    echo -e "${GREEN}🎉 All SVGs generated successfully!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some SVGs failed to generate${NC}"
    exit 1
fi