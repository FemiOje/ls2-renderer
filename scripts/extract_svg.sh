#!/bin/bash

# Extract SVG output from Death Mountain Renderer tests
# This script runs the tests and extracts the raw SVG data to files

# Create output directory if it doesn't exist
mkdir -p output

# Function to extract SVG from a specific test
extract_svg_from_test() {
    local test_name=$1
    local output_name=$2
    
    echo "🔍 Extracting SVG from $test_name..."
    
    # Run the test and capture output
    test_output=$(scarb test $test_name 2>&1)
    
    # Extract the base64 data URI from the test output
    base64_data=$(echo "$test_output" | grep -o 'data:application/json;base64,[A-Za-z0-9+/=]*' | head -1 | sed 's/data:application\/json;base64,//')
    
    if [ -n "$base64_data" ]; then
        echo "📋 Found base64 metadata, decoding..."
        
        # Decode the base64 JSON
        json_content=$(echo "$base64_data" | base64 -d 2>/dev/null)
        
        if [ $? -eq 0 ] && [ -n "$json_content" ]; then
            echo "✅ Successfully decoded JSON metadata"
            
            # Extract the SVG from the image field (it's also base64 encoded)
            svg_base64=$(echo "$json_content" | grep -o '"image":"data:image/svg+xml;base64,[^"]*"' | sed 's/"image":"data:image\/svg+xml;base64,//' | sed 's/"//')
            
            if [ -n "$svg_base64" ]; then
                echo "🎨 Found SVG data, decoding..."
                
                # Decode the SVG base64 data
                echo "$svg_base64" | base64 -d > "output/${output_name}.svg" 2>/dev/null
                
                if [ $? -eq 0 ] && [ -s "output/${output_name}.svg" ]; then
                    echo "✅ SVG successfully extracted to output/${output_name}.svg"
                    echo "📏 SVG file size: $(wc -c < "output/${output_name}.svg") bytes"
                    echo "🎨 SVG preview: $(head -c 100 "output/${output_name}.svg")..."
                    
                    # Save the full decoded JSON metadata as well
                    echo "$json_content" | jq . > "output/${output_name}_metadata.json" 2>/dev/null || echo "$json_content" > "output/${output_name}_metadata.json"
                    echo "📄 JSON metadata saved to output/${output_name}_metadata.json"
                    
                    # Convert SVG to PNG using rsvg-convert
                    if command -v rsvg-convert &> /dev/null; then
                        echo "🔄 Converting SVG to PNG..."
                        
                        # Build rsvg-convert command with width parameter  
                        WIDTH=800
                        rsvg-convert -w $WIDTH -o "output/${output_name}.png" "output/${output_name}.svg"
                        
                        if [ $? -eq 0 ]; then
                            echo "🖼️  PNG created: output/${output_name}.png"
                        else
                            echo "❌ PNG conversion failed for ${output_name}"
                        fi
                    else
                        echo "⚠️  rsvg-convert not found, skipping PNG conversion"
                        echo "💡 To install rsvg-convert: sudo apt-get install librsvg2-bin (Ubuntu/Debian)"
                        echo "💡 Or: brew install librsvg (macOS)"
                    fi
                    echo ""
                else
                    echo "❌ Failed to decode SVG data"
                fi
            else
                echo "❌ Could not find SVG data in JSON"
            fi
        else
            echo "❌ Failed to decode base64 JSON data"
        fi
    else
        echo "❌ Failed to extract base64 metadata from test output"
        echo "🔍 Test output preview:"
        echo "$test_output" | head -5
    fi
}

# Extract SVGs from different renderer tests
echo "🚀 Starting SVG extraction from Death Mountain Renderer tests..."
echo ""

# Tests that actually output SVG metadata
echo "📋 Tests with SVG Output:"
extract_svg_from_test "test_basic_render" "basic_render"
extract_svg_from_test "test_svg_and_json_structure" "svg_json_structure"

echo "🔤 Name Truncation Tests:"
extract_svg_from_test "test_name_truncation_over_31_chars" "name_truncated_35_chars"
extract_svg_from_test "test_name_truncation_exactly_31_chars" "name_boundary_31_chars" 
extract_svg_from_test "test_name_no_truncation_under_31_chars" "name_short_22_chars"
extract_svg_from_test "test_name_no_truncation_exactly_30_chars" "name_boundary_30_chars"
extract_svg_from_test "test_name_truncation_empty_name" "name_empty"

echo ""
echo "⚠️  Note: Most tests only print status messages, not full SVG data."
echo "   Only the above tests contain 'println!' statements with full metadata."
echo ""

# Optional: Run other tests but only for completeness (they won't produce SVG files)
echo "📊 Other Tests (Status Only):"
echo "   Running additional tests for completeness..."
echo "   These tests validate functionality but don't output SVG data."

# Run a few key tests silently to show they work
for test_name in "test_short_name_24px_font" "test_maximum_stats_values" "test_critical_health_red_bar" "test_comprehensive_max_scenario"; do
    echo -n "   • $test_name: "
    if scarb test "$test_name" >/dev/null 2>&1; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
    fi
done

echo ""
echo "🎉 SVG extraction complete!"
echo "📁 Check the output/ directory for generated files:"
if [ -d "output" ]; then
    echo ""
    echo "📄 Generated Files:"
    ls -la output/ | grep -E '\.(svg|png|json)$' | while read -r line; do
        echo "   $line"
    done
    
    echo ""
    echo "📊 File Summary:"
    svg_count=$(ls output/*.svg 2>/dev/null | wc -l)
    png_count=$(ls output/*.png 2>/dev/null | wc -l)
    json_count=$(ls output/*.json 2>/dev/null | wc -l)
    
    echo "   SVG files: $svg_count"
    echo "   PNG files: $png_count"
    echo "   JSON files: $json_count"
else
    echo "❌ No output directory found"
fi

echo ""
echo "💡 Usage tips:"
echo "   - Open SVG files in a web browser or SVG viewer"
echo "   - PNG files can be viewed in any image viewer"
echo "   - JSON files contain the full NFT metadata"
echo "   - Use 'file output/*.svg' to verify SVG validity"