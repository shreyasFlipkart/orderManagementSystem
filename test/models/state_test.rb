require 'test_helper'

class StateTest < ActiveSupport::TestCase
  # Setup a state object before each test method
  setup do
    @state = states(:one)
  end

  # Test case to ensure the state object is initially valid
  test 'valid state' do
    assert @state.valid?
  end

  # Test case for name presence validation
  test 'name should be present' do
    @state.name = ''
    assert_not @state.valid?
    assert_includes @state.errors[:name], "can't be blank" # Assumes presence validation on name
  end

  # Test case for name uniqueness validation
  test 'name should be unique' do
    duplicate_state = @state.dup
    @state.save
    assert_not duplicate_state.valid?
    assert_includes duplicate_state.errors[:name], 'has already been taken' # Assumes uniqueness validation on name
  end

end
