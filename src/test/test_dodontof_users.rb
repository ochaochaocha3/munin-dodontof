require 'minitest/autorun'

require_relative 'test_helper'

class TestDodontofUsers < Minitest::Test
  def setup
    ENV['config_dir'] = File.expand_path('DodontoF_WebSet/DodontoF/src_ruby',
                                         File.dirname(__FILE__))
    ENV['savedata_dir'] = File.expand_path('DodontoF_WebSet/saveData')

    @script_path = File.expand_path('../dodontof_users.rb',
                                    File.dirname(__FILE__))
  end

  def test_config
    output = `ruby #{@script_path} config`

    assert_match(/^graph_title DodontoF login users$/, output)
    assert_match(/^LoginUsers\.warning 30$/, output)
    assert_match(/^LoginUsers\.critical 100$/, output)
  end

  def test_fetch
    output = `ruby #{@script_path}`

    expected = <<EOS
LoginUsers.value 5
AboutMaxLoginCount.value 30
LimitLoginCount.value 100
EOS

    assert_equal expected, output
  end
end
