require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one) # Using the fixture
  end

  test "should get index" do
    get '/getEvents'
    assert_response :success
    assert_includes @response.body, @event.name
  end

  test "should create event" do
    assert_difference('Event.count', 1) do
      post '/addEvent', params: { event: { name: 'new event' } }, as: :json
    end
    assert_response :created
    json_response = JSON.parse(@response.body)
    assert_equal 'new event', json_response["name"]
  end

  test "should not create event with existing name" do
    assert_no_difference('Event.count') do
      post '/addEvent', params: { event: { name: @event.name } }, as: :json
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(@response.body)
    assert_equal "Event with the name '#{@event.name}' already exists.", json_response["error"]
  end

  test "should delete event not used in transitions" do
    event_not_in_transitions = events(:two)
    assert_difference('Event.count', -1) do
      delete "/deleteEvent/#{event_not_in_transitions.id}"
    end
    assert_response :ok
  end

  test "should not delete event used in transitions" do
    Transition.create!(event: @event, from_state: states(:one), to_state: states(:two))

    assert_no_difference('Event.count') do
      delete "/deleteEvent/#{@event.id}"
    end
    assert_response :forbidden
  end
end
