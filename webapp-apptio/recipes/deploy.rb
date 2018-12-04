#This recipe runs every time a new version of the application is deployed by AWS CodePipeline


#app_path is the path to clone the repository to. If the path doesn't exist on the instance, AWS OpsWorks Stacks creates it.

app = search(:aws_opsworks_app).first
app_path = "/var/www/html/"

package "git" do
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "16.04"
end

#git gets the source code from the specified repository and branch if there is a delta

 git app_path do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
  end

# Restart Apache after deployment

bash "restart_apache" do
  user 'root'
  ignore_failure false
  code <<-EOL
    service httpd restart
  EOL
end
