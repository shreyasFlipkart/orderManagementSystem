require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @default_state = states(:created)
    @processing_state = states(:processing) # Assumes a 'states' fixture for processing state
  end

  test "should get index" do
    get '/getOrders'
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count', 1) do
      post '/createOrder', as: :json
    end
    assert_response :created
    json_response = JSON.parse(@response.body)
    assert_equal @default_state.id, json_response['cur_state_id']
  end

  test "should update order state through event" do
    post "/order/#{@order.id}/payment_initiated", as: :json
    assert_response :ok
    @order.reload

    assert_equal "Processing", @order.cur_state.name, "Order state should be updated to Processing"
  end

  test "should get orders by state" do
    get get_orders_by_state_url(@processing_state.name)
    assert_response :success
  end

  test "should get order state" do
    get order_state_url(id: @order.id)
    assert_response :success
  end

  test "should get order created at" do
    get order_created_at_url(id: @order.id) # Correct usage of dynamic segment
    assert_response :success
  end

  test "should delete order" do
    assert_difference('Order.count', -1) do
      delete "/deleteOrder/#{@order.id}"
    end
    assert_response :no_content
  end

  test "should return not found for invalid state" do
    get "/getOrders/NonexistentState"
    assert_response :not_found
  end
end
