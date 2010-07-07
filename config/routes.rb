ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :password_resets
  map.root :controller => "activities", :action => "index"
end
