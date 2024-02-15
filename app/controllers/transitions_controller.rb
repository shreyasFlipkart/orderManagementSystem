class TransitionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /getTransitions
  def index
    @transitions = Transition.includes(:event, :from_state, :to_state).all

    transitions_with_names = @transitions.map do |transition|
      {
        id: transition.id,
        event_name: transition.event.name,
        from_state_name: transition.from_state.name,
        to_state_name: transition.to_state.name
      }
    end

    render json: transitions_with_names
  end

  def create
    event = Event.find_by(name: transition_params[:event_name])
    from_state = State.find_by(name: transition_params[:from_state_name])
    to_state = State.find_by(name: transition_params[:to_state_name])

    if event.blank? || from_state.blank? || to_state.blank?
      render json: { error: "Invalid event or state names" }, status: :unprocessable_entity
      return
    end

    existing_transition = Transition.find_by(event: event, from_state: from_state, to_state: to_state)
    if existing_transition.present?
      render json: { error: "Transition already exists for the given event and state names." }, status: :unprocessable_entity
      return
    end

    duplicate_transition = Transition.where(from_state: from_state, to_state: to_state).exists?

    if duplicate_transition
      render json: { error: "A transition with the specified from and to states already exists." }, status: :unprocessable_entity
      return
    end

    @transition = Transition.new(event: event, from_state: from_state, to_state: to_state)
    if @transition.save
      render json: @transition, status: :created
    else
      render json: @transition.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @transition = Transition.find(params[:id])
    @transition.destroy
    head :no_content
  end

  private

  def transition_params
    params.require(:transition).permit(:event_name, :from_state_name, :to_state_name)
  end
end
