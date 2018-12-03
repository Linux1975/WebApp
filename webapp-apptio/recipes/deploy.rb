#This recipe runs every time a new version of the application is deployed by AWS CodePipeline

app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}""

package "git" do
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "16.04"
end

git app_path do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
  end

bash "restart_apache" do
  user 'root'
  ignore_failure false
  code <<-EOL
    service httpd restart
  EOL
end
