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
    @state = State.find(params[:id])
    @state.destroy
    head :no_content
  end

  private
  def state_params
    params.require(:state).permit(:name)
  end

end
