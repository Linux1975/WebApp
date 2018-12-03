#Install monit to check Apache , if there is no Apache PID it ewill restart the Process and send a notification to a configured
#Slack group
#

bash 'setup-monit-yum' do
    user 'root'
    ignore_failure false
    code <<-EOH
    yum install -y monit
    EOH
end


template "/etc/monit.conf" do
    source "monit.conf.erb"
    owner "root"
    group "root"
    mode 0600
end

template "/etc/monit.d/slack" do
    source "slack.conf.erb"
    owner "root"
    group "root"
    mode 0500
end

# Enable monit service
service "monit" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable]
end

#Start monit
service "monit" do
    supports :status => true, :restart => true, :reload => true
    action [ :restart]
end
