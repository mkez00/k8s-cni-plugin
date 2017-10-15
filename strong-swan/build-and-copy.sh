go build -o strong-swan
cp strong-swan $CNI_PATH/strong-swan
cp 15-sswan.conf /etc/cni/net.d/15-sswan.conf
cd $GOPATH/src/github.com/containernetworking/cni/scripts
CNI_PATH=$CNI_PATH ./priv-net-run.sh ifconfig
