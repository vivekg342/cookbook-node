#
# Cookbook Name:: node
# Recipe:: default
#
# Copyright 2011, Tikibooth Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "git"

[ "curl"].each do |pkg|
  package pkg do
    action :install
  end
end

if node[:node][:install_from_source]
  include_recipe "node::source"
else
  case node[:platform]
    when "debian","ubuntu"
      package "nodejs"
    else
      log("Installing Node from packages is only supported under Ubuntu and Debian.") { level :error }
  end
end

bash "install_npm" do
  user "root"
    cwd "/tmp/"
    code <<-EOH
    curl -k https://npmjs.org/install.sh | clean=no sh
    EOH
end

user node[:node][:user] do
  system true
end