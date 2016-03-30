require_relative 'munin_plugin'

dodontof_users = MuninPlugin.new do
  @config_dir = ENV['config_dir']
  @config_files = [
    File.join(@config_dir, 'config.rb'),
    File.join(@config_dir, 'config_local.rb')
  ]

  @savedata_dir = ENV['savedata_dir']

  def load_config
    @config_files.each do |config_file|
      begin
        load(config_file)
      rescue LoadError
        # 無視する
      end
    end

    @login_count_path = File.join(@savedata_dir, $loginCountFile)
    @about_max_login_count = $aboutMaxLoginCount
    @limit_login_count = $limitLoginCount
  end

  # ログイン人数を返す
  def get_login_users
    File.read(@login_count_path).to_i
  end

  config do |c|
    load_config

    # graph_configure
    c['graph_title']    = 'DodontoF login users'
    c['graph_category'] = 'DodontoF'
    c['graph_args']     = '--base 1000 --lower-limit 0'
    c['graph_scale']    = 'no'
    c['graph_vlabel']   = 'rooms'
    c['graph_info']     = 'This graph shows number of DodontoF login users.'

    # Create login user tag
    c['LoginUsers.label']    = 'login users'
    c['LoginUsers.type']     = 'GAUGE'
    c['LoginUsers.info']     = 'DodontoF login users'
    c['LoginUsers.draw']     = 'AREA'
    c['LoginUsers.warning']  = @about_max_login_count
    c['LoginUsers.critical'] = @limit_login_count

    # Create about max login tag
    c['AboutMaxLoginCount.label']  = 'about max login'
    c['AboutMaxLoginCount.type']   = 'GAUGE'
    c['AboutMaxLoginCount.info']   = 'DodontoF max login allowance'
    c['AboutMaxLoginCount.draw']   = 'LINE2'
    c['AboutMaxLoginCount.colour'] = 'ff8000'

    # Create limit login tag
    c['LimitLoginCount.label']  = 'limit login'
    c['LimitLoginCount.type']   = 'GAUGE'
    c['LimitLoginCount.info']   = 'DodontoF limit login'
    c['LimitLoginCount.draw']   = 'LINE1'
    c['LimitLoginCount.colour'] = 'ff0000'

    # graph_order
    c['graph_order'] = 'LoginUsers AboutMaxLoginCount LimitLoginCount'
  end

  fetch do |result|
    load_config

    result['LoginUsers']         = get_login_users
    result['AboutMaxLoginCount'] = @about_max_login_count
    result['LimitLoginCount']    = @limit_login_count
  end
end

dodontof_users.run
