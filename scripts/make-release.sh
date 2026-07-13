#!/bin/sh
set -e
# Load project version
PKG_VERSION=$(cat ./package.json | jq -r ".version")
# First, clean the project and prevous releases
echo "Removing old files..."
rm -rf ./dist/ ./node_modules/ ./*.zip
# Compile it again
echo "Compiling code..."
npm ci && npm run build && mage -v
# Make distribution files
echo "Compacting release files..."
PLUGIN_ID="albertowd-oraclegrafana-datasource"
# Grafana's installer reuares the zip to contain a top-level directory anmed after the plugin ID
mv ./dist/ ./${PLUGIN_ID}

zip -r ${PLUGIN_ID}-bundle-${PKG_VERSION}.zip ${PLUGIN_ID}/ --exclude="${PLUGIN_ID}/gpx*arm*"
zip -r ${PLUGIN_ID}-darwin-amd64-${PKG_VERSION}.zip ${PLUGIN_ID}/ --exclude="${PLUGIN_ID}/gpx*arm*" --exclude="${PLUGIN_ID}/gpx*linux*" --exclude="${PLUGIN_ID}/gpx*windows*"
zip -r ${PLUGIN_ID}-linux-amd64-${PKG_VERSION}.zip ${PLUGIN_ID}/ --exclude="${PLUGIN_ID}/gpx*arm*" --exclude="${PLUGIN_ID}/gpx*darwin*" --exclude="${PLUGIN_ID}/gpx*windows*"
zip -r ${PLUGIN_ID}-windows-amd64-${PKG_VERSION}.zip ${PLUGIN_ID}/ --exclude="${PLUGIN_ID}/gpx*arm*" --exclude="${PLUGIN_ID}/gpx*darwin*" --exclude="${PLUGIN_ID}/gpx*linux*"
mv ./${PLUGIN_ID}/ ./dist