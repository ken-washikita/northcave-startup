#!/bin/bash

# @sacloud-name "Northcave Setup"
# @sacloud-once
#
# @sacloud-require-archive distro-centos distro-ver-7.*
#
# @sacloud-desc-begin
#   Linuxサーバを自分好みに設定します。
#     スクリプトの実体は https://github.com/ken-washikita/northcave-startup にあります。
#   ※ このスクリプトは、CentOS7.Xで動作します
# @sacloud-desc-end

# load & exec
curl -L https://raw.githubusercontent.com/ken-washikita/northcave-startup/master/centos7/startup.sh | bash

# end
