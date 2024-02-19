require 'test_helper'

class OrderInvalidTransitionTest < ActionDispatch::IntegrationTest
  test "invalid transition does not change order state" do
    post '/createOrder', as: :json
    assert_response :success
    @order = Order.last

    # Attempt to ship an order that is still in the 'Created' state
    post "/order/#{@order.id}/order_shipped", as: :json
    assert_response :unprocessable_entity
    @order.reload
    assert_equal states(:created).id, @order.cur_state_id
  end
end