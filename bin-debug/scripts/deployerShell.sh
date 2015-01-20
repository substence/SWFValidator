#!/bin/bash

# Inline code on a Jenkins Deployer.

# Auto Versioning Assets:
# This code will attempt to unpack the tar'd asset folder sent from the build job, then execute the script found inside(pushVersionedAssets.sh)
# That script lives in warlords/scripts and will sync this folder to the cdn bucket.
# -omartinez

EXIT_LEVEL=0 #0 for warning, 1 for failure
FC_WORKSPACE_ROOT=flashclient #points to the directory of FBClient artifact directory

echo 'Running AVA inline deployer script'
echo
echo 'Checking AVA prerequisites'
echo "Asset Deploy: ${ASSETS_DEPLOY}"

if [ "${ASSETS_DEPLOY}" != 'true' ] || [ ! -d "${FC_WORKSPACE_ROOT}" ]; then
  echo 'AVA prerequisites not met, exiting'
  exit ${EXIT_LEVEL}
fi

echo 'AVA prerequisites met, setting up AVA enviorment variables'
SSH_KEY="$HOME/.ssh/id_rsa_kxcdn"
CDN_USER=kxcdn
CDN_SSH_HOST=cdn-web1.sjc.kixeye.com
CDN_ROOT=/opt/cc/public_html/war-fb

#Setup CDN bucket name based on dev enviorment(currently only supports dev1-6)
if [ "${DEPLOY_ENV}" = "dev1" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev1
elif [ "${DEPLOY_ENV}" = "dev2" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev2
elif [ "${DEPLOY_ENV}" = "dev3" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev3
elif [ "${DEPLOY_ENV}" = "dev4" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev4
elif [ "${DEPLOY_ENV}" = "dev5" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev5
elif [ "${DEPLOY_ENV}" = "dev6" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev6
  elif [ "${DEPLOY_ENV}" = "dev7" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev7
elif [ "${DEPLOY_ENV}" = "dev8" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev8
elif [ "${DEPLOY_ENV}" = "dev9" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev9
elif [ "${DEPLOY_ENV}" = "dev10" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev10
elif [ "${DEPLOY_ENV}" = "dev11" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev11
 elif [ "${DEPLOY_ENV}" = "dev12" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev12
elif [ "${DEPLOY_ENV}" = "stage" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamestage
elif [ "${DEPLOY_ENV}" = "preview" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamepreview
elif [ "${DEPLOY_ENV}" = "ci" ]; then
    CDN_ENV_ROOT=${CDN_ROOT}/gameci
elif [ "${DEPLOY_ENV}" = "qa" ]; then
      CDN_ENV_ROOT=${CDN_ROOT}/gameqa
elif [ "${DEPLOY_ENV}" = "loadtest" ]; then
    CDN_ENV_ROOT=${CDN_ROOT}/gameloadtest
elif [ "${DEPLOY_ENV}" = "live" ]; then
    CDN_ENV_ROOT=${CDN_ROOT}/game
fi

if [ -z "${CDN_ENV_ROOT+xxx}" ]; then
  echo "Could not find a CDN bucket for this enviorment: ${DEPLOY_ENV}"
  exit ${EXIT_LEVEL}
fi

echo 'Navigating to FBClient artifact directory'
ls -al
cd ${FC_WORKSPACE_ROOT} || echo 'Could not navigate to FBClient artifact directory ${FC_WORKSPACE_ROOT}' exit ${EXIT_LEVEL}
pwd

echo 'Unpacking AVA folder'
ls -al
tar xvzf assets_v2.tar.gz || echo 'Could not unpack asset_v2' exit ${EXIT_LEVEL}

echo 'Deleting unpacked AVA folder'
rm -rfv assets_v2.tar.gz || echo 'Could not remove tarball' exit ${EXIT_LEVEL}
ls -al

echo 'Navigating inside AVA'
cd assets_v2 || echo 'Could not navigate to asset_v2 folder' exit ${EXIT_LEVEL}

echo 'Running pushVersionedAssets.sh'
sh ./pushVersionedAssets.sh ${SSH_KEY} ${CDN_USER} ${CDN_SSH_HOST} ${CDN_ENV_ROOT} || echo 'Could not run pushVersionedAssets.sh' ls -al exit ${EXIT_LEVEL}

echo 'Moving back to root project directory'
cd ../..
pwd

echo 'Finished AV2 inline deployer script'

###########################################
# AWS Deployer ######################
###########################################
#!/bin/bash

# Inline code on a Jenkins Deployer.

# Auto Versioning Assets:
# This code will attempt to unpack the tar'd asset folder sent from the build job, then execute the script found inside(pushVersionedAssets.sh)
# That script lives in warlords/scripts and will sync this folder to the cdn bucket.
# -omartinez

EXIT_LEVEL=0 #0 for warning, 1 for failure
FC_WORKSPACE_ROOT=flashclient #points to the directory of FBClient artifact directory

echo 'Running AVA inline deployer script'
echo
echo 'Checking AVA prerequisites'

if [ ! -d "${FC_WORKSPACE_ROOT}" ]; then
  echo 'AVA prerequisites not met, exiting'
  exit ${EXIT_LEVEL}
fi

echo 'AVA prerequisites met, setting up AVA enviorment variables'
SSH_KEY="$HOME/.ssh/id_rsa_kxcdn"
CDN_USER=kxcdn
CDN_SSH_HOST=cdn-web1.sjc.kixeye.com
CDN_ROOT=/opt/cc/public_html/war-fb

#Setup CDN bucket name based on dev enviorment(currently only supports dev1-6)
if [ "${AWS_DEV_ENVIRONMENT}" = "Dev7" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev7
elif [ "${AWS_DEV_ENVIRONMENT}" = "Dev8" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev8
elif [ "${AWS_DEV_ENVIRONMENT}" = "Dev9" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev9
elif [ "${AWS_DEV_ENVIRONMENT}" = "Dev10" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev10
elif [ "${AWS_DEV_ENVIRONMENT}" = "Dev11" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev11
elif [ "${AWS_DEV_ENVIRONMENT}" = "Dev12" ]; then
  CDN_ENV_ROOT=${CDN_ROOT}/gamedev12
fi

if [ -z "${CDN_ENV_ROOT+xxx}" ]; then
  echo "Could not find a CDN bucket for this enviorment: ${AWS_DEV_ENVIRONMENT}"
  exit ${EXIT_LEVEL}
fi

echo 'Navigating to FBClient artifact directory'
ls -al
cd ${FC_WORKSPACE_ROOT} || echo 'Could not navigate to FBClient artifact directory ${FC_WORKSPACE_ROOT}' exit ${EXIT_LEVEL}
pwd

echo 'Unpacking AVA folder'
ls -al
tar xvzf assets_v2.tar.gz || echo 'Could not unpack asset_v2' exit ${EXIT_LEVEL}

echo 'Deleting unpacked AVA folder'
rm -rfv assets_v2.tar.gz || echo 'Could not remove tarball' exit ${EXIT_LEVEL}
ls -al

echo 'Navigating inside AVA'
cd assets_v2 || echo 'Could not navigate to asset_v2 folder' exit ${EXIT_LEVEL}

echo 'Running pushVersionedAssets.sh'
sh ./pushVersionedAssets.sh ${SSH_KEY} ${CDN_USER} ${CDN_SSH_HOST} ${CDN_ENV_ROOT} || echo 'Could not run pushVersionedAssets.sh' ls -al exit ${EXIT_LEVEL}

echo 'Moving back to root project directory'
cd ../..
pwd

echo 'Finished AV2 inline deployer script'
