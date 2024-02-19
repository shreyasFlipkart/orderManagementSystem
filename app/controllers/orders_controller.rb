class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /order/:id/:event
  def trigger_event
    order = Order.find_by(id: params[:id])
    event_name = params[:event]

    if order.present? && order.handle_event(event_name)
      Rails.application.config.access_logger.info "Order state updated: #{order.id}, Event: #{event_name}"
      render json: { success: "Order state updated successfully to #{order.cur_state.name}." }, status: :ok
    else
      Rails.application.config.error_logger.error "Order state update failed: #{params[:id]}, Event: #{event_name}"
      render json: { error: "Order not found or no applicable transition found for event." }, status: :unprocessable_entity
    end
  end

  def show
    order = Order.find(params[:id])
    Rails.application.config.access_logger.info "Order details accessed: #{order.id}"
    render json: order
  rescue ActiveRecord::RecordNotFound
    Rails.application.config.error_logger.error "Order not found: #{params[:id]}"
    render json: { error: "Order not found" }, status: :not_found
  end

  # GET /getOrders
  def index
    @orders = Order.all
    Rails.application.config.access_logger.info "Accessed getOrders API"
    render json: @orders
  end

  # DELETE /deleteOrder/:id
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    Rails.application.config.application_logger.info "Order deleted: #{params[:id]}"
    head :no_content
  end

  # POST /addOrder
  def create
    @order = Order.new(default_order_params)
    if @order.save
      Rails.application.config.application_logger.info "Order created: #{@order.id}"
      render json: @order, status: :created
    else
      Rails.application.config.error_logger.error "Order creation failed: Errors: #{@order.errors.full_messages.join(", ")}"
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
    state = State.find_by(name: params[:state])
    if state.present?
      @orders = Order.where(cur_state_id: state.id)
      render json: @orders
    else
      render json: { error: "Invalid state" }, status: :not_found
    end
  end

  private

  def default_order_params
    { cur_state_id: default_state_id, order_timestamp: Time.current }
  end

  def default_state_id
    State.find_by(name: 'Created')&.id
  end
end
