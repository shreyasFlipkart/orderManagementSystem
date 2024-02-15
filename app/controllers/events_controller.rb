class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /getEvents
  def index
    @events = Event.all
    render json: @events
  end

  # POST /addEvent
  def create
    existing_event = Event.find_by(name: event_params[:name])
    if existing_event
      render json: { error: "Event with the name '#{event_params[:name]}' already exists." }, status: :unprocessable_entity
    else
      @event = Event.new(event_params)
      if @event.save
        render json: @event, status: :created
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /deleteEvent/:id
  def destroy
    event = Event.find(params[:id])
    used_in_transitions = Transition.where(event_id: event.id)

    if used_in_transitions.exists?
      transition_ids = used_in_transitions.pluck(:id)
      render json: { error: "Event cannot be deleted because it is used in transitions (IDs: #{transition_ids.join(', ')})" }, status: :forbidden
    else
      event.destroy
      render json: { success: "Event deleted successfully." }, status: :ok
    end
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end
end
