class Transition < ApplicationRecord
belongs_to :event
belongs_to :from_state, class_name: 'State', foreign_key: 'from_state_id'
belongs_to :to_state, class_name: 'State', foreign_key: 'to_state_id'
validates :event, presence: true
validates :from_state, presence: true
validates :to_state, presence: true
validate :from_and_to_state_must_be_different


private

def from_and_to_state_must_be_different
  errors.add(:to_state_id, "must be different from from_state") if from_state_id == to_state_id
end
end