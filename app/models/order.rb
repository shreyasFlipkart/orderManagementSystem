class Order < ApplicationRecord
  belongs_to :cur_state, class_name: 'State', foreign_key: 'cur_state_id'
  validates :cur_state_id, presence: true
  validates :order_timestamp, presence: true

  # Method to handle event and transition state
  def handle_event(event_name)
    event = Event.find_by(name: event_name)
    return false if event.nil?
    transition = Transition.find_by(event: event, from_state: cur_state)
    if transition
      update(cur_state: transition.to_state)
      true
    else
      false
    end
  end

end
