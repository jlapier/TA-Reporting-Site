ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'activities', :action => 'index'
  map.resources :activities, :collection => {:auto_complete_for_activity_objective => :post}
  map.resources :objectives
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :password_resets
  map.resources :states
  map.resources :reports
end
