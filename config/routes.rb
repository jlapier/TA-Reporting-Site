ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'activities', :action => 'index'
  map.resources :activities, :collection => {:auto_complete_for_activity_objective => :post}
end
