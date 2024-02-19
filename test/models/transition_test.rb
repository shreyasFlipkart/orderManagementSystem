require "test_helper"

class TransitionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @event = events(:one)
    @from_state = states(:one)
    @to_state = states(:two)
    @transition = Transition.new(event: @event, from_state: @from_state, to_state: @to_state)
  end

  test 'should be valid' do
    assert @transition.valid?
  end

  test 'event should be present' do
    @transition.event = nil
    assert_not @transition.valid?
  end

  test 'from_state should be present' do
    @transition.from_state = nil
    assert_not @transition.valid?
  end

  test 'to_state should be present' do
    @transition.to_state = nil
    assert_not @transition.valid?
  end

  test 'from_state and to_state should be different' do
    @transition.to_state = @transition.from_state
    assert_not @transition.valid?
  end
end
