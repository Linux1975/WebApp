#
#
#

# -- Install the basic software
bash 'setup-apache-yum' do
    user 'root'
    ignore_failure false
    code <<-EOH
    yum install -y httpd
    cd /root
    wget https://s3-us-west-2.amazonaws.com/techops-interview-webapp/webapp.tar.gz #create an S3 bucket in my account with public and dist folder
    tar xvzf webapp.tar.gz
    cp -p public/s* /var/www/html/
    service httpd start
    chkconfig httpd on
    EOH
end

# Raplce existing configuration files with configuration from unified templates
# Get the Chef::CookbookVersion for this cookbook
cb = run_context.cookbook_collection['webapp']

# Remove default httpd config files
bash 'httpd-remove-existing-config' do
    user 'root'
    ignore_failure false
    code <<-EOH
    rm -f /etc/httpd/conf/*.*
    rm -f /etc/httpd/conf.d/*.*
    rm -f /etc/httpd/conf.modules.d/*.*
    EOH
end

# Loop through and copy all http configuration templates
cb.manifest['templates'].each do |cbf|
  filepath = cbf['path']

  # Only parse unified specific config templates
  next if not filepath.include? "templates/webapp/"
  filepath = filepath.sub("templates/webapp/httpd/", '')

template "/etc/httpd/#{filepath}" do
    source "webapp/httpd/#{filepath}"
    mode 0755
    owner "ec2-user"
    group "ec2-user"
  end
end


bash "restart_apache" do
  user 'root'
  ignore_failure false
  code <<-EOL
    service httpd restart
  EOL
end
