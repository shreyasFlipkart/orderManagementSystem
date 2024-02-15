class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /getEvents
  def index
    @events = Event.all
    render json: @events
  end

  # POST /addEvent
  def create
    @event = Event.new(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /deleteEvent/:id
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    head :no_content
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end
end
