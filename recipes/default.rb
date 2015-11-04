#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "httpd" do
  action :install
end

# Disable the default virtual host
apache_vhost "welcome" do
  action :delete
  notifies :restart, "service[httpd]"
end

# Iterate over the apache sites
node["apache"]["sites"].each do |site_name, site_data|
  apache_vhost site_name do
    site_port site_data['port']
    # action :create
    notifies :restart, "service[httpd]"
  end
end

service "httpd" do
  action [ :enable, :start ]
end
