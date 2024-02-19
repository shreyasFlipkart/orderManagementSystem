require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # test/models/event_test.rb
  require 'test_helper'

  class EventTest < ActiveSupport::TestCase
    def setup
      @event = events(:one)
    end

    test 'valid event' do
      assert @event.valid?
    end

    test 'name should be present' do
      @event.name = ' '
      assert_not @event.valid?
    end

    test 'name should be unique' do
      duplicate_event = @event.dup
      @event.save
      assert_not duplicate_event.valid?
    end
  end

end
