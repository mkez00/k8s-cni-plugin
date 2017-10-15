// Copyright 2017 CNI authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/containernetworking/cni/pkg/skel"
	"github.com/containernetworking/cni/pkg/version"
	"github.com/containernetworking/plugins/pkg/ns"
	"github.com/containernetworking/cni/pkg/types"
	"github.com/vishvananda/netlink"
)

type NetConfig struct {
	NetworkInterface string `json:networkInterface` //interface name: ie. enp0s3
}

func init() {
	// this ensures that main runs only on main thread (thread group leader).
	// since namespace ops (unshare, setns) are done for a single thread, we
	// must ensure that the goroutine does not jump from OS thread to thread
	runtime.LockOSThread()
}

func loadConf(bytes []byte) (*NetConfig, error) {
	n := &NetConfig{}
	if err := json.Unmarshal(bytes, n); err != nil {
		return nil, fmt.Errorf("failed to load netconf: %v", err)
	}
	if n.NetworkInterface == "" {
		return nil, fmt.Errorf(`Network interface required"`)
	}
	return n, nil
}

func cmdAdd(args *skel.CmdArgs) error {
	//cfg, err := loadConf(args.StdinData)
	//if err != nil {
	//	return err
	//}
	//lo, _ := netlink.LinkByName(cfg.NetworkInterface)
	//addr, _ := netlink.ParseAddr("169.254.169.154/32")
	//
	//return netlink.AddrAdd(lo, addr)

	for idx, rangeset := range ipamConf.Ranges {

	}

	return nil
}

func cmdDel(args *skel.CmdArgs) error {
	lo, _ := netlink.LinkByName("enp0s3")
	addr, _ := netlink.ParseAddr("169.254.169.154/32")
	return netlink.AddrDel(lo,addr)
}

func main() {
	skel.PluginMain(cmdAdd, cmdDel, version.All)
}