ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'activities', :action => 'index'
  map.resources :activities
  map.resources :criteria
  map.resources :activity_types, :controller => 'criteria'
  map.resources :objectives, :controller => 'criteria'
  map.resources :ta_categories, :controller => 'criteria'
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :password_resets
  map.resources :states
  map.resources :collaborating_agencies
  map.resources :reports, :member => {:export => :post} do |report|
    report.resources :report_breakdowns
  end
  map.resource :user_session
end
