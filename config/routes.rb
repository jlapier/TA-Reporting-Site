ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'activities', :action => 'index'
  map.resources :activities
  map.resources :criteria
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :password_resets
  map.resources :states
  map.resources :collaborating_agencies
  map.resources :reports
  map.resource :user_session
end
