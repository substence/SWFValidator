#!/bin/bash

# This script is run from inline code on a Jenkins Build.

# Create an Asset Manifest, compress it, then commit back to 'warlords'.

cd ..
echo 'Starting AVA script(createAssetManifest.sh)'

echo '# Constructing Asset Manifest'
echo '{' > tempAssetManifest.json
echo '# Build body of asset manifest'
find src/staging/assets -type f -iname "*.png" -o -iname "*.jpg" -o -iname "*.swf" -o -iname "*.flv" -o -iname "*.mp4" | xargs md5sum | awk '{ print "\"" $2 "\"" ":" "\"" $1 "\"" "," }' > assetManifest.body.json
echo '# Cleanse asset names'
cat assetManifest.body.json | sed -e 's/src\/staging\/assets\///g' -e 's///g' > assetManifest.body.cleaned.json
echo '# Sort assets alphabetically'
cat assetManifest.body.cleaned.json | sort > assetManifest.body.sorted.json
echo '# Combine assetManifest json doc with body'
cat assetManifest.body.sorted.json | sed -e '$s/,//g' >> tempAssetManifest.json
echo '# Finish asset manifest doc'
echo '}' >> tempAssetManifest.json
echo

echo '# Moving tmp working file to master assetManifest namespace'
mv -v tempAssetManifest.json assetManifest.json
echo

echo '# Clean-up working docs'
rm -fv assetManifest.body.json
rm -fv assetManifest.body.cleaned.json
rm -fv assetManifest.body.sorted.json
echo

echo '# Show Generated Asset Manifest'
cat assetManifest.json
echo

echo '# Diff Asset Manifest to determine if its changed or not'
echo

echo '# Decompressing old manifest for comparison'
echo
python scripts/zlibDecompressFile.py src/staging/assets/assetManifest.data assetManifest.old.json

# echo "# Checking for decompressed assetManifest.data"
# echo
#
# if [ -f assetManifest.old.json ]
#   then
#   echo "# Diffing Old / New Asset Manifest to determine any deltas"
#   assetManifestDiff=`diff <( sort <( cat assetManifest.old.json | python -mjson.tool | sed -e 's/,//g' ) ) <( sort <( cat assetManifest.json | python -mjson.tool | sed -e 's/,//g' ) )`
#   if [[ $assetManifestDiff == "" ]]
#     then
#     echo
#     echo '# No Difference between old and new asset manifest'
#     echo
#   else
#     echo '# Asset Manifest Delta Detected'
#     echo '-----------------------------'
#     prettyDelta=`echo $assetManifestDiff | grep '^\(>\|<\)' | sed -e 's/</< (old) /g' -e 's/>/> (new) /g'`
#     echo $prettyDelta
#     echo '-----------------------------'
#     echo
#   fi
#
#   echo '# Removing old asset manifest used for comparison'
#   rm -fv assetManifest.old.json
#   echo
#
# else
#   echo '# Previous Asset Manifest not available to running diff against'
# fi
# echo
# echo

echo 'Cleaning de-compressed old Asset Manifest'
rm -fv assetManifest.old.json
echo

echo 'Copying assetManifest to target destination'
mv assetManifest.json src/staging/assets/assetManifest.json
echo

echo 'Compressing Asset Manifest'
python scripts/zlibCompressFile.py src/staging/assets/assetManifest.json src/staging/assets/assetManifest.data
echo

cd src/staging/assets/
#echo 'Committing Manifest to warlords SVN'
#svn add assetManifest.data
#svn commit assetManifest.data -m 'Updating Asset Manifest'
#echo

echo 'Checking out wc-data bin folder'
cd ../../../
svn co https://scm.kixeye.com/svn/wc-data/${BRANCH}/bin
cd bin

echo 'Copying the assetManifest to the local bin copy'
cp -f ../src/staging/assets/assetManifest.json .

echo 'Committing Manifest to wc-data bin'
svn add assetManifest.json
svn commit assetManifest.json -m 'Updating Asset Manifest'

echo 'Cleaning up local bin folder'
cd ..
rm -f -r bin
rm -f assetManifest.json

#
# Copy all assets and rename them to include their MD5.
#

echo 'Create assets folder'
mkdir assets_v2

echo 'Copy assets to new folder'
cd src/staging/assets/
rsync -av --exclude '*.svn' --exclude '.svn' --include '*/' --include '*.jpg' --include '*.png' --include '*.swf' --include '*.flv' --include '*.mp4' --exclude '*' . ../../../assets_v2
cd ../../../

echo 'Rename files to include md5'
for f in $(find assets_v2 -name "*.*"); do nf=`md5sum "$f" | awk '{ print substr($2,1,length($2)-3)$1"."substr($2,length($2)-2)  }'`; mv -v "$f" "$nf"; done

echo 'Copy deployer script into folder'
cp -f scripts/pushVersionedAssets.sh assets_v2

echo 'Copy Manifest into folder'
cp -f src/staging/assets/assetManifest.data assets_v2

echo "Create tar from assets_v2 folder"
tar -czvf assets_v2.tar.gz assets_v2
rm -rfv assets_v2
