require 'minitest/autorun'

require_relative 'test_helper'

class TestDodontofRooms < Minitest::Test
  def setup
    ENV['config_dir'] = File.expand_path('DodontoF_WebSet/DodontoF/src_ruby',
                                         File.dirname(__FILE__))
    ENV['savedata_dir'] = File.expand_path('DodontoF_WebSet/saveData')
    ENV['warn_percentage'] = '90'

    @script_path = File.expand_path('../dodontof_rooms.rb',
                                    File.dirname(__FILE__))
  end

  def test_config
    output = `ruby #{@script_path} config`

    assert_match(/^graph_title DodontoF play rooms$/, output)
    assert_match(/^BusyRooms.warning 9$/, output)
  end

  def test_fetch
    output = `ruby #{@script_path}`

    expected = <<EOS
BusyRooms.value 1
FreeRooms.value 9
Total.value 10
EOS

    assert_equal expected, output
  end
end
