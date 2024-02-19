require "test_helper"

class TransitionsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup do
    @transition = transitions(:payment_initiation_to_processing)
    @event = events(:payment_initiated)
    @from_state = states(:created)
    @to_state = states(:processing)
  end


  test "should get index" do
    get '/getTransitions', as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_empty json_response
  end

  test "should create transition" do
    unique_to_state = State.create!(name: "UniqueState_#{Time.now.to_i}")

    assert_difference('Transition.count', 1) do
      post '/addTransition', params: {
        transition: {
          event_name: @event.name,
          from_state_name: @from_state.name,
          to_state_name: unique_to_state.name
        }
      }, as: :json
    end

    assert_response :created
  end

  test "should not create duplicate transition" do
    assert_no_difference('Transition.count') do
      post '/addTransition', params: {
        transition: {
          event_name: @transition.event.name,
          from_state_name: @transition.from_state.name,
          to_state_name: @transition.to_state.name
        }
      }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "should delete transition" do
    new_transition = Transition.create!(event: @event, from_state: @from_state, to_state: @to_state)
    assert_difference('Transition.count', -1) do
      delete "/deleteTransition/#{new_transition.id}", as: :json
    end
    assert_response :no_content
  end
end
