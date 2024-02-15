class Order < ApplicationRecord
  belongs_to :cur_state, class_name: 'State', foreign_key: 'cur_state_id'

  # Method to handle event and transition state
  def handle_event(event_name)
    # Find the event by its name
    event = Event.find_by(name: event_name)
    return false if event.nil?
    # Find a transition for the current state and event
    transition = Transition.find_by(event: event, from_state: cur_state)
    if transition
      # If a valid transition is found, update the order's current state
      update(cur_state: transition.to_state)
      true
    else
      false
    end
  end

end
