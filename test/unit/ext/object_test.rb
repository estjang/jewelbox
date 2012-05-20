require 'minitest/autorun'
require 'jewelbox/ext/object'

class MyTestClass
end

class JewelboxObjectTest < MiniTest::Unit::TestCase

  def test_eigenclass
    ec = MyTestClass.eigenclass
    ec.send(:define_method, :test1) do |x|
      return x + x
    end
    assert_equal(4, MyTestClass.test1(2))
  end

end


