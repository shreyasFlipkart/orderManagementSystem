class StatesController < ApplicationController
  # GET /getStates
   skip_before_action :verify_authenticity_token
  def index
    @states = State.all
    render json: @states
  end

  # POST /addState
  def create
    @state = State.new(state_params)
    if @state.save
      render json: @state, status: :created
    else
      render json: @state.errors, status: :unprocessable_entity
    end
  end

  # DELETE /deleteState/:id
  def destroy
    state = State.find(params[:id])
    used_in_orders = Order.where(cur_state_id: state.id)
    used_in_transitions = Transition.where("from_state_id = ? OR to_state_id = ?", state.id, state.id)

    if used_in_orders.exists? || used_in_transitions.exists?
      error_message = "State cannot be deleted because it is used in "
      errors = []

      if used_in_orders.exists?
        order_ids = used_in_orders.pluck(:id)
        errors << "orders (IDs: #{order_ids.join(', ')})"
      end

      if used_in_transitions.exists?
        transition_ids = used_in_transitions.pluck(:id)
        errors << "transitions (IDs: #{transition_ids.join(', ')})"
      end

      render json: { error: error_message + errors.join(' and ') + "." }, status: :forbidden
    else
      state.destroy
      render json: { success: "State deleted successfully." }, status: :ok
    end
  end

  private
  def state_params
    params.require(:state).permit(:name)
  end

end
