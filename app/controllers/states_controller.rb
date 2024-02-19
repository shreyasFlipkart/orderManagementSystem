class StatesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /getStates
  def index
    @states = State.all
    Rails.application.config.access_logger.info "Accessed getStates API"
    render json: @states
  end

  # POST /addState
  def create
    existing_state = State.find_by(name: state_params[:name])

    if existing_state
      Rails.application.config.error_logger.error "State creation failed: State with name '#{state_params[:name]}' already exists."
      render json: { error: "State with the name '#{state_params[:name]}' already exists." }, status: :unprocessable_entity
    else
      @state = State.new(state_params)
      if @state.save
        Rails.application.config.application_logger.info "State created: #{@state.id}"
        render json: @state, status: :created
      else
        Rails.application.config.error_logger.error "State creation failed: Errors: #{@state.errors.full_messages.join(", ")}"
        render json: @state.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /deleteState/:id
  def destroy
    state = State.find(params[:id])
    used_in_orders = Order.where(cur_state_id: state.id)
    used_in_transitions = Transition.where("from_state_id = ? OR to_state_id = ?", state.id, state.id)

    if used_in_orders.exists? || used_in_transitions.exists?
      order_ids = used_in_orders.pluck(:id)
      transition_ids = used_in_transitions.pluck(:id)
      error_message = "State cannot be deleted because it is used in orders (IDs: #{order_ids.join(', ')}) and transitions (IDs: #{transition_ids.join(', ')})"

      Rails.application.config.error_logger.error error_message
      render json: { error: error_message }, status: :forbidden
    else
      state.destroy
      Rails.application.config.application_logger.info "State deleted: #{state.id}"
      render json: { success: "State deleted successfully." }, status: :ok
    end
  end

  private
  def state_params
    params.require(:state).permit(:name)
  end
end
