ENV['SERVICE_ROOT'] = File.expand_path(File.dirname(__FILE__))
require 'minitest/autorun'
require 'jewelbox'

class JewelboxConfigTest < MiniTest::Unit::TestCase

  def setup
    Jewelbox.service_init
  end

  def test_service_config
    assert_equal('clocktower', Jewelbox.config.service.name)
    assert_equal(80100, Jewelbox.config.service.webui_port)
    assert_equal(80100, Jewelbox.config.service.api_port)
    assert_equal(80101, Jewelbox.config.service.worker_port)
    assert_equal(4, Jewelbox.config.service.num_workers)
    assert_equal(Jewelbox.config.service.root_dir + "/conf", Jewelbox.config.service.conf_dir)
    assert_equal(Jewelbox.config.service.root_dir + "/log", Jewelbox.config.service.log_dir)
    assert_equal(Jewelbox.config.service.root_dir + "/bin", Jewelbox.config.service.bin_dir)
    assert_equal(Jewelbox.config.service.root_dir + "/lib", Jewelbox.config.service.lib_dir)
  end

  def test_section1
    assert_equal(true, Jewelbox.config.section1.directive1)
    assert_equal(100, Jewelbox.config.section1.directive2)
    assert_equal("string x", Jewelbox.config.section1.directive3)
    assert_equal("string y", Jewelbox.config.section1.directive4)
    assert_equal(["array", "of", "strings"], Jewelbox.config.section1.directive5)
    assert_equal({"key1" => "val1", "key2" => "val2", "key3" => "val3"}, Jewelbox.config.section1.directive6)
  end

  def test_section2
    Jewelbox::Config.load(Jewelbox.config.service.conf_dir + "/additional.yml")
    assert_equal(false, Jewelbox.config.section2.directive1)
    assert_equal(200, Jewelbox.config.section2.directive2)
  end

end

