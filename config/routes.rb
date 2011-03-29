TAReportingSite::Application.routes.draw do
  root :to => 'activities#new'
  resources :activities do
    collection do
      get :evaluate
      get :download
      get :update_grant_activities
    end
  end

  resources :criteria
  resources :intensity_levels, :controller => 'criteria'
  resources :grant_activities, :controller => 'criteria'
  resources :ta_delivery_methods, :controller => 'criteria'
  resources :objectives, :controller => 'criteria'
  resources :ta_categories, :controller => 'criteria'
  resource :account, :controller => 'users'
  resources :users
  resources :password_resets
  resources :states
  resources :collaborating_agencies
  resources :reports do
    member do
      get :download
      get :summary_map
      get :ytd_map
      #get :summary
    end
    resources :report_breakdowns
  end

  resources :summary_reports do
    member do
      get :summary_map
      get :ytd_map
      get :evaluation
    end
  end

  resource :user_session
end

