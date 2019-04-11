export dg=rt-nightly
newt install
rt_runner -g $dg --job=$JOB_NAME -- bash -e -x -c '
echo $RUNTIME_CI_LINK
#newt target amend bebop_dev_evt syscfg=GWDBG=1:CLI_MAX_NAMESPACES=16
newt build bebop_dev_evt
#newt test all --exclude net/ip/mn_socket/test,net/oic/test,lib/K4_heater/test,lib/heater/test,lib/psense_mgr/test,boot/bootutil/test
runtime build gc -g $dg --yes
newt create-image -e keys/ci-rsa-enc-pubkey.pem -2 bebop_dev_evt 0.11.$BUILD_NUMBER keys/ci-rsa-key.pem
build_id1=$(runtime build upload -g $dg -s --path . --target bebop_dev_evt)
newt create-image -e keys/ci-rsa-enc-pubkey.pem -2 bebop_dev_evt 0.12.$BUILD_NUMBER keys/ci-rsa-key.pem
build_id2=$(runtime build upload -g $dg -s --path . --target bebop_dev_evt)
cd etc/automatic-invention
git checkout master
old_build=$(cat evt_build_B)
echo $old_build > evt_build_C
echo $build_id1 > evt_build_A
echo $build_id2 > evt_build_B
git config --global user.email "david.lee@juul.com"
git config --global user.name "David Lee"
git add .
git commit -m "update nightly builds"
git push origin master
'