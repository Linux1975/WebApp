#This recipe runs every time a new version of your application is deployed by AWS CodePipeline

bash 'deploy ' do
    user 'root'
    ignore_failure false
    code <<-EOH
    service  httpd stop
    cd /root
    wget https://s3-us-west-2.amazonaws.com/techops-interview-webapp/webapp.tar.gz
    tar xvzf webapp.tar.gz
    cp -p public/* /var/www/html/
    chkconfig httpd on
    EOH
end
