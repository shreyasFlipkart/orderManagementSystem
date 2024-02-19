require 'test_helper'

class OrderCancellationTest < ActionDispatch::IntegrationTest
  setup do
    # Assuming you have fixtures or factory methods to create these
    @processed_state = states(:processed)
    @void_state = states(:void)
    @order = Order.create!(
      cur_state: @processed_state,
      order_timestamp: Time.current
    )
  end

  test "order cancellation transitions order to void state" do
    # Apply the cancellation event to the order
    post "/order/#{@order.id}/order_cancelled", as: :json
    assert_response :success

    @order.reload
    assert_equal @void_state.id, @order.cur_state_id
  end
end# frozen_string_literal: true

