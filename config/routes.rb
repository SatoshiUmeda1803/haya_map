Rails.application.routes.draw do
  get 'time_settings/edit'
  root to: 'routes#new'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resource :user, only: %i[new create]
  resource :time_setting, only: %i[edit update]
  resource :route, only: %i[new show]
end
