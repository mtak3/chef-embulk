package "curl"

group node[:embulk][:group] do
  system true
end

user node[:embulk][:user] do
  system true
  group  node[:embulk][:group]
end

bash "download embulk.jar" do
  user  node[:embulk][:user]
  group node[:embulk][:group]
  code  <<-EOC
  curl -L #{node[:embulk][:download_uri]} -o #{node[:embulk][:jar]}
  chmod +x #{node[:embulk][:jar]}
EOC
  creates node[:embulk][:jar]
end

template node[:embulk][:bin] do
  owner  node[:embulk][:user]
  group  node[:embulk][:group]
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
  mode     0744
  source   "Gemfile.erb"
  notifies :run, "bash[embulk-bundle-install]", :immediately
end

bash "embulk-bundle-install" do
  action :nothing
  user   node[:embulk][:user]
  group  node[:embulk][:group]
  code   "#{node[:embulk][:jar]} bundle"
end
