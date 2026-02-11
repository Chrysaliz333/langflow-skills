#!/bin/bash
# Build script for langflow-skills distribution packages
# Creates zip files for both Claude.ai (individual skills) and Claude Code (bundle)

set -e

DIST_DIR="dist"
VERSION="1.0.0"

echo "🔨 Building langflow-skills distribution packages..."

# Create dist directory if it doesn't exist
mkdir -p "$DIST_DIR"

# Remove old zips
echo "🗑️  Removing old zip files..."
rm -f "$DIST_DIR"/*.zip

# Build individual skill zips (for Claude.ai)
echo "📦 Building individual skill zips for Claude.ai..."

SKILLS=(
    "langflow-api-expert"
    "langflow-component-config"
    "langflow-custom-components"
    "langflow-flow-patterns"
    "langflow-build-expert"
    "langflow-agent-patterns"
)

for skill in "${SKILLS[@]}"; do
    echo "   - $skill"
    zip -rq "$DIST_DIR/${skill}-v${VERSION}.zip" "skills/${skill}/" -x "*.DS_Store"
done

# Build complete bundle (for Claude Code)
echo "📦 Building complete bundle for Claude Code..."
zip -rq "$DIST_DIR/langflow-skills-v${VERSION}.zip" \
    .claude-plugin/ \
    README.md \
    LICENSE \
    MIGRATION_ANALYSIS.md \
    skills/ \
    -x "*.DS_Store"

# Show results
echo ""
echo "✅ Build complete! Files in $DIST_DIR/:"
echo ""
ls -lh "$DIST_DIR"/*.zip 2>/dev/null || echo "No zip files created yet"
echo ""
echo "📊 Package sizes:"
du -h "$DIST_DIR"/*.zip 2>/dev/null || echo "No zip files to measure"
