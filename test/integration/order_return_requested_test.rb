require 'test_helper'

class OrderReturnRequestTest < ActionDispatch::IntegrationTest
  setup do
    @delivered_state = states(:delivered)
    @void_state = states(:void)

    @order = Order.create!(
          cur_state: @delivered_state,
          order_timestamp: Time.current
        )
  end

  test "return request transitions order to void state" do
    post "/order/#{@order.id}/return_requested", as: :json
    assert_response :success

    @order.reload
    assert_equal @void_state.id, @order.cur_state_id
  end
end