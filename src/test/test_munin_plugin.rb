require 'minitest/autorun'

require_relative 'test_helper'
require_relative '../munin_plugin.rb'

class TestMuninPlugin < Minitest::Test
  def setup
    @plugin = MuninPlugin.new
  end

  def test_do_config
    @plugin.config do |c|
      c['graph_title']  = 'Load average'
      c['graph_vlabel'] = 'Load'
      c['load.label']   = 'load'
    end

    expected_stdout = <<EOS
graph_title Load average
graph_vlabel Load
load.label load
EOS

    assert_output expected_stdout do
      @plugin.send(:do_config)
    end
  end

  def test_do_fetch
    @plugin.fetch do |r|
      r['load']  = 0.08
      r['load2'] = 0.1
    end

    expected_stdout = <<EOS
load.value 0.08
load2.value 0.1
EOS

    assert_output expected_stdout do
      @plugin.send(:do_fetch)
    end
  end
end
