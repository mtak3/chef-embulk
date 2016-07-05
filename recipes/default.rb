package "curl"

group node[:embulk][:group] do
end

user node[:embulk][:user] do
  group  node[:embulk][:group]
	manage_home true
end

bash "download embulk.jar" do
  user  "root"
  group "root"
  code  <<-EOC
  curl -L #{node[:embulk][:download_uri]} -o #{node[:embulk][:jar]}
  chmod +x #{node[:embulk][:jar]}
EOC
  creates node[:embulk][:jar]
end

template node[:embulk][:bin] do
  owner  "root"
  group  "root"
  mode   0755
  source "embulk.erb"
end

bash "embulk-mkbundle" do
  not_if { Dir.exists?("#{node[:embulk][:lib_dir]}") }
  user   node[:embulk][:user]
  group  node[:embulk][:group]
	code   "#{node[:embulk][:jar]} mkbundle #{node[:embulk][:lib_dir]}"
end

template "#{node[:embulk][:lib_dir]}/Gemfile" do
  owner    node[:embulk][:user]
  group    node[:embulk][:group]
  mode     0644
  source   "Gemfile.erb"
  notifies :run, "bash[embulk-bundle-install]", :immediately
end

bash "embulk-bundle-install" do
  action :nothing
  user   node[:embulk][:user]
  group  node[:embulk][:group]
	cwd    "#{node[:embulk][:lib_dir]}"
  code   "#{node[:embulk][:jar]} bundle"
end
