default[:embulk] = {
  :bin          => "/usr/local/bin/embulk",
  :jar          => "/usr/local/bin/embulk.jar",
  :download_uri => "http://dl.embulk.org/embulk-latest.jar",
  :lib_dir      => "/home/embulk/.embulk",
  :config_dir   => "/hime/embulk/.embulk/config",
  :user         => "embulk",
  :group        => "embulk",
  :plugins      => [
    {:name => "embulk-input-jdbc",},
    {:name => "embulk-output-jdbc",},
    # {:name => "plugin-name", :version => "~> 0.0.1",},
  ],
}
