class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  # POST /order/:id/:event
  def trigger_event
    order = Order.find_by(id: params[:id])
    event_name = params[:event]

    if order.present? && order.handle_event(event_name)
      render json: { success: "Order state updated successfully to #{order.cur_state.name}." }, status: :ok
    else
      render json: { error: "Order not found or no applicable transition found for event." }, status: :unprocessable_entity
    end
  end

  # GET /getOrders
  def index
    @orders = Order.all
    render json: @orders
  end

    # DELETE /deleteOrder/:id
    def destroy
      @order = Order.find(params[:id])
      @order.destroy
      head :no_content
    end
  # POST /addOrder
  def create
    @order = Order.new(default_order_params)
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end
  def state
    order = Order.find_by(id: params[:id])
    if order
      state_name = order.cur_state&.name
      if state_name
        render json: { id: order.id, state: state_name }
      else
        render json: { error: "State not found" }, status: :not_found
      end
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end
  def created_at
    order = Order.find_by(id: params[:id])
    if order
      render json: { id: order.id, created_at: order.created_at }
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end
  def by_state
    # Attempt to find the state by its name
    state = State.find_by(name: params[:state])

    if state.present?
      # If the state exists, find all orders with that state
      @orders = Order.where(cur_state_id: state.id)
      render json: @orders
    else
      # If the state does not exist, render an error message
      render json: { error: "Invalid state" }, status: :not_found
    end
  end

  private

  def default_order_params
    { cur_state_id: default_state_id, order_timestamp: Time.current }
  end

  def default_state_id
    # Determine and return a default state ID, if applicable
    State.find_by(name: 'Created')&.id

  end






end
