require 'minitest/autorun'
require 'jewelbox/ext/time'

class JewelboxTimeTest < MiniTest::Unit::TestCase

  def setup
    @t = Time.parse("2012-07-30T18:00:02-07:00")
  end

  def test_iso_8601
    assert_equal("2012-07-30T18:00:02-0700", @t.iso_8601)
  end

end


