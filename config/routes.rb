Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Api's to get add or delete states

  get '/getStates', to: 'states#index'
  post '/addState', to: 'states#create'
  delete '/deleteState/:id', to: 'states#destroy'

  # Api's to get add or delete Order, get orders by state
  get '/getOrders', to: 'orders#index'
  post '/createOrder', to: 'orders#create'
  delete '/deleteOrder/:id', to: 'orders#destroy'
  get '/getOrders/:state', to: 'orders#by_state', as: 'get_orders_by_state'
  get '/getOrder/:id/state', to: 'orders#state', as: 'order_state'
  get '/getOrder/:id/createdAt', to: 'orders#created_at', as: 'order_created_at'

  post '/order/:id/:event', to: 'orders#trigger_event'



  # Api's to get add or delete Events
  get '/getEvents', to: 'events#index'
  post '/addEvent', to: 'events#create'
  delete '/deleteEvent/:id', to: 'events#destroy'
  # Api's to get add or delete Transitions
  get '/getTransitions', to: 'transitions#index'
  post '/addTransition', to: 'transitions#create'
  delete '/deleteTransition/:id', to: 'transitions#destroy'



  # Defines the root path route ("/")
  # root "posts#index"
end
