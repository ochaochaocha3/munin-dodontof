require_relative 'munin_plugin'

# 部屋クラス
class Room
  # 部屋番号
  attr_reader :id
  # セーブデータディレクトリへの絶対パス
  attr_reader :savedata_dir

  # コンストラクタ
  def initialize(id, savedata_dir)
    @id = id
    @savedata_dir = savedata_dir
    @json_path = File.join(@savedata_dir, "data_#{@id}/playRoomInfo.json")
  end

  # 部屋が使われているかどうかを返す
  # @return [Boolean]
  def used?
    File.exist?(@json_path)
  end
end

dodontof_rooms = MuninPlugin.new do
  @config_dir = ENV['config_dir']
  @config_files = [
    File.join(@config_dir, 'config.rb'),
    File.join(@config_dir, 'config_local.rb')
  ]

  @savedata_dir = ENV['savedata_dir']
  @warn_percentage = ENV['warn_percentage'].to_i

  # 最大部屋数を返す
  def get_num_of_rooms
    @config_files.each do |config_file|
      begin
        load(config_file)
      rescue LoadError
        # 無視する
      end
    end

    $saveDataMaxCount
  end

  config do |c|
    num_of_rooms = get_num_of_rooms

    # graph_configure
    c['graph_title']    = 'DodontoF play rooms'
    c['graph_category'] = 'DodontoF'
    c['graph_args']     = '--base 1000 --lower-limit 0'
    c['graph_scale']    = 'no'
    c['graph_vlabel']   = 'rooms'
    c['graph_info']     = 'This graph shows the number of DodontoF play rooms.'

    # busy_rooms_tag
    busy_rooms_warning_value = num_of_rooms * @warn_percentage / 100
    c['BusyRooms.label']    = 'busy rooms'
    c['BusyRooms.type']     = 'GAUGE'
    c['BusyRooms.info']     = 'DodontoF busy rooms'
    c['BusyRooms.draw']     = 'AREA'
    c['BusyRooms.warning']  = busy_rooms_warning_value
    c['BusyRooms.critical'] = num_of_rooms

    # free_rooms_tag
    c['FreeRooms.label'] = 'free rooms'
    c['FreeRooms.type']  = 'GAUGE'
    c['FreeRooms.info']  = 'DodontoF free rooms'
    c['FreeRooms.draw']  = 'STACK'

    # total_tag
    c['Total.label']  = 'total'
    c['Total.type']   = 'GAUGE'
    c['Total.info']   = 'DodontoF total rooms'
    c['Total.draw']   = 'LINE1'
    c['Total.colour'] = '000000'

    # graph_order
    c['graph_order'] = 'BusyRooms FreeRooms Total'
  end

  fetch do |result|
    num_of_rooms = get_num_of_rooms
    rooms = (0...num_of_rooms).map { |i| Room.new(i, @savedata_dir) }
    num_of_used_rooms = rooms.
      select(&:used?).
      length

    result['BusyRooms'] = num_of_used_rooms
    result['FreeRooms'] = num_of_rooms - num_of_used_rooms
    result['Total']     = num_of_rooms
  end
end

dodontof_rooms.run
