class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /getEvents
  def index
    @events = Event.all
    Rails.application.config.access_logger.info "Accessed getEvents API"
    render json: @events
  end

  # POST /addEvent
  def create
    existing_event = Event.find_by(name: event_params[:name])
    if existing_event
      Rails.application.config.error_logger.error "Attempt to create duplicate event: #{event_params[:name]}"
      render json: { error: "Event with the name '#{event_params[:name]}' already exists." }, status: :unprocessable_entity
    else
      @event = Event.new(event_params)
      if @event.save
        Rails.application.config.application_logger.info "Event created: #{event_params[:name]}"
        render json: @event, status: :created
      else
        Rails.application.config.error_logger.error "Failed to create event: #{event_params[:name]}, errors: #{@event.errors.full_messages.join(", ")}"
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
      Rails.application.config.error_logger.error "Attempted to delete event used in transitions: #{event.name}, Transition IDs: #{transition_ids.join(', ')}"
      render json: { error: "Event cannot be deleted because it is used in transitions (IDs: #{transition_ids.join(', ')})" }, status: :forbidden
    else
      event.destroy
      Rails.application.config.application_logger.info "Event deleted: #{event.name}"
      render json: { success: "Event deleted successfully." }, status: :ok
    end
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end
end
