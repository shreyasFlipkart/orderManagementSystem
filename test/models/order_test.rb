require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @order = orders(:one)
  end

  test 'should be valid' do
    assert @order.valid?
  end

  test 'should require cur_state_id' do
    @order.cur_state_id = nil
    assert_not @order.valid?
    assert_includes @order.errors[:cur_state_id], "can't be blank"
  end

  test 'order_timestamp should be present' do
    @order.order_timestamp = nil
    assert_not @order.valid?
    assert_includes @order.errors[:order_timestamp], "can't be blank"
  end
end
