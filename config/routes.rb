TAReportingSite::Application.routes.draw do
  match '/' => 'activities#new'
  resources :activities do
    collection do
      get :update_grant_activities
      get :edit_all
    end
  end

  resources :criteria
  resources :intensity_levels
  resources :grant_activities
  resources :ta_delivery_methods
  resources :objectives
  resources :ta_categories
  resource :account
  resources :users
  resources :password_resets
  resources :states
  resources :collaborating_agencies
  resources :reports do
    member do
      get :download
      get :preview
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

