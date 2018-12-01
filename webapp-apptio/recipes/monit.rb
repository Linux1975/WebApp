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


service "monit" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable]
end
