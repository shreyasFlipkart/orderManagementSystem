require "test_helper"

class StatesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup do
    @state = states(:created)
  end

  # Test index action
  test "should get index" do
    get '/getStates', as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_empty json_response
  end

  test "should create state" do
    assert_difference('State.count') do
      post '/addState', params: { state: { name: 'New State' } }, as: :json
    end
    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 'New State', json_response['name']
  end

  test "should not create state with duplicate name" do
    assert_no_difference('State.count') do
      post '/addState', params: { state: { name: @state.name } }, as: :json
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "State with the name '#{@state.name}' already exists.", json_response['error']
  end

  test "should delete state" do
    new_state = State.create(name: 'Temporary State')
    assert_difference('State.count', -1) do
      delete "/deleteState/#{new_state.id}", as: :json
    end
    assert_response :ok
  end

  test "should not delete state if used in orders or transitions" do
    assert_no_difference('State.count') do
      delete "/deleteState/#{@state.id}", as: :json
    end
    assert_response :forbidden
  end

end
