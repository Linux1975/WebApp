#
#
#

# -- Install the basic software
bash 'setup-apache-yum' do
    user 'root'
    ignore_failure false
    code <<-EOH
    yum install -y httpd
    wget https://s3-us-west-2.amazonaws.com/techops-interview-webapp/webapp.tar.gz #create an S3 bucket in my account with public and dist folder
    tar xvzf webapp.tar.gz
    cp -p public/s* /var/www/html/
    cp -p public/index.html /var/www/html/
    service httpd start
    chkconfig httpd on
    EOH
end

# Provision index.html to ensure ELB health check passes
template "/var/www/html/index.html" do
    source "apache-default-index.erb"
    owner "ec2-user"
    group "ec2-user"
    mode 0644
end
