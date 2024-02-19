require 'test_helper'

class OrderLifecycleTest < ActionDispatch::IntegrationTest

  test "order lifecycle from creation to delivery" do
    post '/createOrder', as: :json
    assert_response :success
    @order = Order.last
    post "/order/#{@order.id}/payment_initiated", as: :json
    assert_response :success
    @order.reload
    assert_equal states(:processing).id, @order.cur_state_id

    post "/order/#{@order.id}/payment_succesful", as: :json
    assert_response :success
    @order.reload
    assert_equal states(:processed).id, @order.cur_state_id

    post "/order/#{@order.id}/order_packaged", as: :json
    assert_response :success
    @order.reload
    assert_equal states(:ready).id, @order.cur_state_id

    post "/order/#{@order.id}/order_shipped", as: :json
    assert_response :success
    @order.reload
    assert_equal states(:shipped).id, @order.cur_state_id

    post "/order/#{@order.id}/order_delivered", as: :json
    assert_response :success
    @order.reload
    assert_equal states(:delivered).id, @order.cur_state_id
  end
end
