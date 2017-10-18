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
	"encoding/json"
	"fmt"
	"runtime"
	"github.com/containernetworking/cni/pkg/skel"
	"github.com/containernetworking/cni/pkg/version"
	"os/exec"
)

type NetConfig struct {
	Left Connection `json:left`
	Right Connection `json:right`
}

type Connection struct {
	Left string `json:left`
	LeftSubnet string `json:leftSubnet`
	LeftFirewall string `json:leftFirewall`
	Right string `json:right`
	RightSubnet string `json:rightSubnet`
	Auto string `json:auto`
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
	return n, nil
}

func cmdAdd(args *skel.CmdArgs) error {
	return restartStrongSwanAndConnect()
}

func restartStrongSwanAndConnect() error{
	err := run(exec.Command("ipsec","restart"))
	if (err!=nil) {
		return err
	}
	run(exec.Command("ipsec","up", "leftNode"))
	if (err!=nil) {
		return err
	}
	run(exec.Command("ipsec","up", "rightNode"))
	if (err!=nil) {
		return err
	}
	return nil
}

func run(cmd *exec.Cmd) error{
	err := cmd.Run()
	if (err!=nil){
		return err
	}
	return nil
}

func cmdDel(args *skel.CmdArgs) error {
	return nil
}

func main() {
	skel.PluginMain(cmdAdd, cmdDel, version.All)
}