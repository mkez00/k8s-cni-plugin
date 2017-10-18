#!/bin/bash
# strong-swan-start.sh
ipsec restart
sleep 5
ipsec up leftNode
ipsec up rightNode
