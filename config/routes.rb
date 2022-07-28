Rails.application.routes.draw do
  get 'time_settings/edit'
  root to: 'routes#new'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create]
  resources :routes, only: %i[new index]
  resources :time_settings, only: %i[edit update]
end
