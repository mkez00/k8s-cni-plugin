if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Going into directory"
cd /go/src/k8s-cni-plugin
echo "Building project"
go get
go build -o strong-swan
echo "Copying binary"
cp /go/src/k8s-cni-plugin/strong-swan /go/src/github.com/containernetworking/plugins/bin/strong-swan
cd /go/src/github.com/containernetworking/cni/scripts/
# echo "Running test"
# CNI_PATH=$CNI_PATH ./priv-net-run.sh ifconfig
echo "Done"
