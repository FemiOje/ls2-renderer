#!/bin/bash

# ========================================================================
# Death Mountain Renderer - Multipage SVG Generator Script
# ========================================================================
# This script generates SVG and PNG outputs for all 4 pages of the multipage NFT system
# Page 0: Inventory (Green theme)
# Page 1: Item Bag (Orange theme)  
# Page 2: Marketplace (Blue theme)
# Page 3: Battle (Red theme)

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

echo -e "${BLUE}📋 Generating SVG outputs for all 4 pages...${NC}"

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

# Function to extract Base64 data URI from test output
extract_base64_from_test() {
    local test_name="$1"
    local page_num="$2"
    local output_file="$3"
    
    echo -e "${YELLOW}   Extracting Base64 data URI for page $page_num${NC}"
    
    # Run the test and capture Base64 output
    scarb test "$test_name" 2>&1 | \
        sed -n "/=== PAGE $page_num BASE64 ===/,/=== END PAGE $page_num BASE64 ===/p" | \
        sed '1d;$d' > "$output_file"
    
    if [ -s "$output_file" ]; then
        echo -e "${GREEN}   ✓ Base64 data URI extracted${NC}"
        return 0
    else
        echo -e "${RED}   ✗ Failed to extract Base64 data URI${NC}"
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

# Generate all 4 pages
generate_page_outputs "0" "Inventory" "Green"
generate_page_outputs "1" "Item Bag" "Orange" 
generate_page_outputs "2" "Marketplace" "Blue"
generate_page_outputs "3" "Battle" "Red"

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
echo "└── size_comparison.txt             - Size comparison stats"
echo ""
echo -e "${BLUE}💡 Usage Tips:${NC}"
echo "• View SVG files in a browser for best quality"
echo "• PNG files are raster versions for external use"
echo "• Data URI files contain base64-encoded images for web embedding"
echo "• Use 'open output/' on macOS or 'xdg-open output/' on Linux to view outputs"
echo ""
echo -e "${GREEN}✨ Happy NFT rendering!${NC}"