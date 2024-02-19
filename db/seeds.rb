# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Seed States
state_names = ['Created', 'Processing', 'Processed', 'Ready', 'Shipped', 'Delivered', 'Void']
states = state_names.map { |name| State.find_or_create_by!(name: name) }

# Seed Events
event_names = ['payment_initiated', 'payment_succesful', 'payment_failed', 'order_packaged', 'order_shipped', 'order_delivered', 'return_requested', 'order_cancelled', 'order_store_delivery', 'delivery_failed']
events = event_names.map { |name| Event.find_or_create_by!(name: name) }

# Seed Transitions
transitions_data = [
  { event_name: 'payment_initiated', from_state_name: 'Created', to_state_name: 'Processing' },
  { event_name: 'payment_succesful', from_state_name: 'Processing', to_state_name: 'Processed' },
  { event_name: 'payment_failed', from_state_name: 'Processing', to_state_name: 'Void' },
  { event_name: 'order_packaged', from_state_name: 'Processed', to_state_name: 'Ready' },
  { event_name: 'order_shipped', from_state_name: 'Ready', to_state_name: 'Shipped' },
  { event_name: 'order_delivered',from_state_name: 'Shipped', to_state_name: 'Delivered' },
  { event_name: 'return_requested', from_state_name: 'Delivered', to_state_name: 'Void' },
  { event_name: 'order_cancelled', from_state_name: 'Processed',to_state_name: 'Void' },
  { event_name: 'order_cancelled', from_state_name: 'Ready', to_state_name: 'Void' },
  { event_name: 'order_store_delivery', from_state_name: 'Ready', to_state_name: 'Delivered' },
  { event_name: 'delivery_failed', from_state_name: 'Shipped', to_state_name: 'Processed' },
]

transitions_data.each do |transition|
  event = events.find { |e| e.name == transition[:event_name] }
  from_state = states.find { |s| s.name == transition[:from_state_name] }
  to_state = states.find { |s| s.name == transition[:to_state_name] }

  Transition.find_or_create_by!(event: event, from_state: from_state, to_state: to_state)
end
