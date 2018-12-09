#-- Install the basic software: Apache will serve the webstatic html page.
# We assume that we use Amazon Linux in our stack.
# We will use the static code provided as a "blueprint" , so every time we spin up a new instance in OpsWorks:
# the starting point will be that code.
# We also include the binary files example-webapp-linux , example-webapp-osx harcoded in our cookbook.
#
#

bash 'setup-apache-yum' do
     user 'root'
     ignore_failure false
     code <<-EOH
     yum install httpd -y
     chkconfig httpd on
     EOH
 end


# Replace existing configuration files with configuration from the blueprint instance
# Get the Chef::CookbookVersion for this cookbook
cb = run_context.cookbook_collection['webapp']

# Remove default httpd config files , we have modified the file httpd.conf :
# mod_mime, and added these lines for using the CSS and the javascript:
#
#AddType text/css .css
#AddType text/javascript .js

bash 'httpd-remove-existing-config' do
    user 'root'
    ignore_failure false
    code <<-EOH
    rm -f /etc/httpd/conf/*.*
    EOH
end

# Loop through and copy all http configuration templates
cb.manifest['templates'].each do |cbf|
  filepath = cbf['path']

# Only parse Apache specific config templates
next if not filepath.include? "templates/webapp/"
filepath = filepath.sub("templates/webapp/httpd/", '')

template "/etc/httpd/#{filepath}" do
    source "webapp/httpd/#{filepath}"
    mode 0755
    owner "root"
    group "root"
  end
end

# Copy the files example-webapp-linux ,example-webapp-osx in /home/ec2-user/
['example-webapp-linux', 'example-webapp-osx'].each do |file|
  cookbook_file "/home/ec2-user/#{file}" do
    source "dist/#{file}"
    mode "0755"
  end

# Provision index.html
template "/var/www/html/index.html" do
    source "apache-default-index.erb"
    owner "root"
    group "root"
    mode 0644
end

# Start Apache at the end of the setup

bash "start_apache" do
  user 'root'
  ignore_failure false
  code <<-EOL
  service httpd start
  EOL
end
