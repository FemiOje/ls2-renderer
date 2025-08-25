#!/bin/bash

# ========================================================================
# Death Mountain Renderer - Multipage SVG Generator Script
# ========================================================================
# This script generates SVG and PNG outputs for all pages of the multipage NFT system
# Page 0: Inventory (Green theme)
# Page 1: Item Bag (Orange theme)  
# Page 2: Battle (Red theme)
# 
# Normal Mode: Pages 0-1 (2-page animated cycle)
# Battle Mode: Page 2 only (static display)

set -e

OUTPUT_DIR="output"
TEMP_DIR="temp_svg_generation"

# Create directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TEMP_DIR"

echo "🎨 Death Mountain Renderer - Multipage SVG Generator"
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Generating SVG outputs for all 3 pages...${NC}"

# Function to extract SVG from test output
extract_svg_from_test() {
    local test_name="$1"
    local page_num="$2"
    local output_file="$3"
    
    echo -e "${YELLOW}   Running test: $test_name${NC}"
    
    # Run the test and capture output
    scarb test "$test_name" 2>&1 | \
        sed -n "/=== PAGE $page_num SVG/,/=== END PAGE $page_num SVG ===/p" | \
        sed '1d;$d' > "$output_file"
    
    if [ -s "$output_file" ]; then
        echo -e "${GREEN}   ✓ SVG extracted successfully${NC}"
        return 0
    else
        echo -e "${RED}   ✗ Failed to extract SVG${NC}"
        return 1
    fi
}

# Function to convert SVG to PNG using various methods
convert_svg_to_png() {
    local svg_file="$1"
    local png_file="$2"
    
    echo -e "${YELLOW}   Converting SVG to PNG...${NC}"
    
    # Try multiple conversion methods
    if command -v inkscape >/dev/null 2>&1; then
        echo -e "${BLUE}   Using Inkscape for conversion${NC}"
        inkscape "$svg_file" --export-type=png --export-filename="$png_file" --export-width=862 --export-height=1270 2>/dev/null
    elif command -v rsvg-convert >/dev/null 2>&1; then
        echo -e "${BLUE}   Using rsvg-convert for conversion${NC}"
        rsvg-convert -w 862 -h 1270 "$svg_file" -o "$png_file"
    elif command -v convert >/dev/null 2>&1; then
        echo -e "${BLUE}   Using ImageMagick convert for conversion${NC}"
        convert -background none -size 862x1270 "$svg_file" "$png_file"
    else
        echo -e "${YELLOW}   ⚠️  No SVG converter found. PNG generation skipped.${NC}"
        echo -e "${YELLOW}   Install inkscape, librsvg2-bin, or imagemagick for PNG conversion${NC}"
        return 1
    fi
    
    if [ -f "$png_file" ]; then
        echo -e "${GREEN}   ✓ PNG converted successfully${NC}"
        return 0
    else
        echo -e "${RED}   ✗ PNG conversion failed${NC}"
        return 1
    fi
}

echo ""
echo -e "${BLUE}🔧 Building Cairo project...${NC}"
scarb build
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Build successful${NC}"

# Function to generate page outputs
generate_page_outputs() {
    local page_num="$1"
    local page_name="$2"
    local theme_color="$3"
    
    echo ""
    echo -e "${BLUE}📄 Page $page_num: $page_name ($theme_color theme)${NC}"
    echo "================================"
    
    if extract_svg_from_test "test_output_all_pages_svg" "$page_num" "$TEMP_DIR/page_$page_num.svg"; then
        local filename_base="page_${page_num}_$(echo $page_name | tr '[:upper:]' '[:lower:]' | tr ' ' '_')"
        cp "$TEMP_DIR/page_$page_num.svg" "$OUTPUT_DIR/${filename_base}.svg"
        
        # Convert to PNG
        convert_svg_to_png "$OUTPUT_DIR/${filename_base}.svg" "$OUTPUT_DIR/${filename_base}.png"
        
        echo -e "${GREEN}✓ Page $page_num outputs generated${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to generate Page $page_num outputs${NC}"
        return 1
    fi
}

# Generate all 3 pages (one test run each for now - can optimize later)
generate_page_outputs "0" "Inventory" "Green"
generate_page_outputs "1" "Item Bag" "Orange" 
generate_page_outputs "2" "Battle" "Red"

# Function to generate animated SVGs
generate_animated_svgs() {
    echo ""
    echo -e "${BLUE}🎬 Generating Animated SVGs for Different States...${NC}"
    echo "=================================================="
    
    local normal_file="$OUTPUT_DIR/animated_normal_mode.svg"
    local battle_file="$OUTPUT_DIR/animated_battle_mode.svg"
    local normal_success=0
    local battle_success=0
    
    # Generate normal mode SVG
    echo -e "${BLUE}📋 Generating Normal Mode SVG...${NC}"
    scarb test test_output_dynamic_animated_svg_comparison 2>&1 | sed -n "/=== NORMAL MODE SVG ===/,/=== END NORMAL MODE SVG ===/p" | sed '1d;$d' > "$normal_file"
    
    if [ -s "$normal_file" ]; then
        echo -e "${GREEN}✅ Normal Mode SVG generated successfully!${NC}"
        echo "📁 File: $normal_file"
        echo "📊 Size: $(ls -lh $normal_file | awk '{print $5}')"
        echo ""
        echo -e "${GREEN}🎨 Normal Mode Features:${NC}"
        echo "  • 10-second cycle (5 seconds per page)"
        echo "  • Page 0: Inventory (Green theme - #78E846)"
        echo "  • Page 1: Item Bag (Orange theme - #E89446)"
        echo "  • Smooth opacity transitions between pages"
        echo "  • Active when adventurer is NOT in battle"
        normal_success=1
    else
        echo -e "${RED}❌ Failed to generate Normal Mode SVG${NC}"
    fi
    
    # Generate battle mode SVG
    echo ""
    echo -e "${BLUE}📋 Generating Battle Mode SVG...${NC}"
    scarb test test_output_dynamic_animated_svg_comparison 2>&1 | sed -n "/=== BATTLE MODE SVG ===/,/=== END BATTLE MODE SVG ===/p" | sed '1d;$d' > "$battle_file"
    
    if [ -s "$battle_file" ]; then
        echo -e "${GREEN}✅ Battle Mode SVG generated successfully!${NC}"
        echo "📁 File: $battle_file"
        echo "📊 Size: $(ls -lh $battle_file | awk '{print $5}')"
        echo ""
        echo -e "${RED}⚔️  Battle Mode Features:${NC}"
        echo "  • Static display (no animation)"
        echo "  • Page 2: Battle page only (Red theme - #FF6B6B)"
        echo "  • Shows current battle interface"
        echo "  • Active when adventurer is IN battle (beast_health > 0)"
        battle_success=1
    else
        echo -e "${RED}❌ Failed to generate Battle Mode SVG${NC}"
    fi
    
    echo ""
    echo "=================================================="
    echo -e "${BLUE}📊 Animated SVG Summary:${NC}"
    echo ""
    
    if [ $normal_success -eq 1 ]; then
        echo -e "${GREEN}✓ Normal Mode SVG:${NC} $normal_file"
    else
        echo -e "${RED}✗ Normal Mode SVG: Failed${NC}"
    fi
    
    if [ $battle_success -eq 1 ]; then
        echo -e "${GREEN}✓ Battle Mode SVG:${NC} $battle_file"  
    else
        echo -e "${RED}✗ Battle Mode SVG: Failed${NC}"
    fi
}

# Generate animated SVGs
generate_animated_svgs

echo ""
echo -e "${BLUE}📊 Generating size comparison...${NC}"

# Run size comparison test
echo -e "${YELLOW}Running size comparison test...${NC}"
scarb test test_simple_svg_comparison 2>&1 | \
    sed -n "/=== SVG SIZE COMPARISON ===/,/=== END COMPARISON ===/p" | \
    sed '1d;$d' > "$OUTPUT_DIR/size_comparison.txt"

if [ -s "$OUTPUT_DIR/size_comparison.txt" ]; then
    echo -e "${GREEN}✓ Size comparison generated${NC}"
    echo ""
    echo -e "${BLUE}📏 Size Comparison Results:${NC}"
    cat "$OUTPUT_DIR/size_comparison.txt"
else
    echo -e "${YELLOW}⚠️  Size comparison unavailable${NC}"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}🎉 Generation complete!${NC}"
echo -e "${BLUE}📁 Output files created in: ${OUTPUT_DIR}/${NC}"
echo ""
echo "Generated files:"
echo "├── page_0_inventory.svg            - Inventory page SVG (Green theme)"
echo "├── page_0_inventory.png            - Inventory page PNG (Green theme)"
echo "├── page_1_item_bag.svg             - Item Bag page SVG (Orange theme)"
echo "├── page_1_item_bag.png             - Item Bag page PNG (Orange theme)"
echo "├── page_2_battle.svg               - Battle page SVG (Red theme)"
echo "├── page_2_battle.png               - Battle page PNG (Red theme)"
echo "├── animated_normal_mode.svg        - Animated SVG for normal mode (2-page cycle)"
echo "├── animated_battle_mode.svg        - Animated SVG for battle mode (single page)"
echo "└── size_comparison.txt             - Size comparison stats"
echo ""
echo -e "${BLUE}🎮 Page System:${NC}"
echo "• Normal Mode: Pages 0-1 (Inventory + Item Bag) in animated cycle"
echo "• Battle Mode: Page 2 only (Battle page) when in combat"
echo "• Animated SVGs: Dynamic state-based rendering for NFT display"
echo ""
echo -e "${BLUE}💡 Usage Tips:${NC}"
echo "• View SVG files in a browser for best quality"
echo "• PNG files are raster versions for external use"
echo "• Animated SVGs show dynamic behavior based on battle state"
echo "• Use 'open output/' on macOS or 'xdg-open output/' on Linux to view outputs"
echo ""
echo -e "${GREEN}✨ Happy NFT rendering!${NC}"