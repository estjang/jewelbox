require 'minitest/autorun'
require 'jewelbox/ext/object'

class MyTestClass
end

class JewelboxTimeTest < MiniTest::Unit::TestCase

  def test_eigenclass
    ec = MyTestClass.eigenclass
    puts ec.name
  end

end


