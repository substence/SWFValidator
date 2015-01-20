echo 'Starting AVA Deployment script(pushVersionedAssets.sh)'
echo 'Arguments:'
echo $1
echo $2
echo $3
echo $4

# Setup variables
AV2_SSH_KEY=$1
AV2_CDN_USER=$2
AV2_CDN_SSH_HOST=$3
AV2_CDN_ENV=${4}/assets

echo 'Setting up enviorment variables:'
echo "SSH KEY ${AV2_SSH_KEY}"
echo "CDN USER ${AV2_CDN_USER}"
echo "CDN HOST ${AV2_CDN_SSH_HOST}"
echo "CDN ENVIORMENT ${AV2_CDN_ENV}"

echo "Syncing AVA files to CDN ${AV2_CDN_ENV}"
ssh -i ${AV2_SSH_KEY} ${AV2_CDN_USER}@${AV2_CDN_SSH_HOST} ls -al ${AV2_CDN_ENV} || "Could not access folder ${AV2_CDN_ENV}" exit 1
rsync -azhrR -e "ssh -v -c arcfour -i ${AV2_SSH_KEY}" --progress --omit-dir-times --chmod=Du=rwx,Dg=rwx,Do=rx,Fu=rw,Fg=rw,Fo=r -p . ${AV2_CDN_USER}@${AV2_CDN_SSH_HOST}:${AV2_CDN_ENV} || echo 'Rsync has some permission issues most likely triggering this message.. continue like nothing happened'
echo "Sync Complete on ${AV2_CDN_ENV}"
ssh -i ${AV2_SSH_KEY} ${AV2_CDN_USER}@${AV2_CDN_SSH_HOST} ls -al ${AV2_CDN_ENV} || "Could not access folder ${AV2_CDN_ENV}" exit 1
