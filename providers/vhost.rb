use_inline_resources

action :create do
  document_root = "/srv/apache/#{new_resource.site_name}"

  if node["region"] == "us-east-1"
    region_override = "None"
  elsif node["region"] = "us-west-1"
    region_override = "All"
  end

  # Add a template for Apache virtual host configuration
  template "/etc/httpd/conf.d/#{new_resource.site_name}.conf" do
    source "custom.erb"
    mode "0644"
    variables(
      :region_override => region_override,
      :document_root => document_root,
      :port => new_resource.site_port
    )
  end

  # Add a directory resource to create the document_root
  directory document_root do
    mode "0755"
    recursive true
  end

  # Add a template resource for the virtual host's index.html
  template "#{document_root}/index.html" do
    source "index.html.erb"
    mode "0644"
    variables(
      :site_name => new_resource.site_name,
      :port => new_resource.site_port
    )
  end
end

action :delete do
  file "/etc/httpd/conf.d/#{new_resource.site_name}.conf" do
    action :delete
  end

  directory "/srv/apache/#{new_resource.site_name}" do
    action :delete
  end
end
