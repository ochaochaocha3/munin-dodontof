require 'rake/clean'

task default: 'all'

PLUGINS = %w(dodontof_rooms)

PLUGINS.each do |plugin|
  CLEAN << plugin
end

desc 'プラグインをインストールする'
task install: :all do |t|
  raise 'root privileges is required' unless Process.uid == 0

  plugin_conf_file = 'plugin-conf.d/dodontof_'
  raise "#{plugin_conf_file} not found" unless File.exist?(plugin_conf_file)

  local_plugins_dir = '/usr/local/munin/lib/plugins'
  local_plugins = PLUGINS.map { |plugin| "#{local_plugins_dir}/#{plugin}" }

  mkdir_p local_plugins_dir
  cp PLUGINS, local_plugins_dir
  chmod 0755, local_plugins
  ln_sf local_plugins, '/etc/munin/plugins'

  cp plugin_conf_file, '/etc/munin/plugin-conf.d'
end

desc 'すべてのプラグインを作成する'
task all: PLUGINS

make_plugin = lambda do |t|
  puts("Making #{t.name}...")

  plugin_header = File.read(t.prerequisites[1], encoding: 'UTF-8')
  plugin_common = File.read(t.prerequisites[2], encoding: 'UTF-8')
  plugin_body = File.read(t.prerequisites[0], encoding: 'UTF-8').
    sub("require_relative 'munin_plugin'\n", '')

  File.open(t.name, 'w:UTF-8') do |f|
    f.print(plugin_header)
    f.print(plugin_common)
    f.print(plugin_body)
  end

  puts("Output #{t.name}")
  chmod(0755, t.name)
end

file(
  {
    'dodontof_rooms' => ['src/dodontof_rooms.rb',
                         'src/dodontof_rooms_header.rb',
                         'src/munin_plugin.rb']
  },
  &make_plugin
)
