#/bin/sh
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
cd ./dist/
zip -r ../albertowd-oraclegrafana-datasource-bundle-${PKG_VERSION}.zip . --exclude="gpx*arm*"
zip -r ../albertowd-oraclegrafana-datasource-darwin-amd64-${PKG_VERSION}.zip . --exclude="gpx*arm*" --exclude="gpx*linux*" --exclude="gpx*windows*"
zip -r ../albertowd-oraclegrafana-datasource-linux-amd64-${PKG_VERSION}.zip . --exclude="gpx*arm*" --exclude="gpx*darwin*" --exclude="gpx*windows*"
zip -r ../albertowd-oraclegrafana-datasource-windows-amd64-${PKG_VERSION}.zip . --exclude="gpx*arm*" --exclude="gpx*darwin*" --exclude="gpx*linux*"
cd ../