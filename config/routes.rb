Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  root to: 'routes#new'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  get 'inquiry', to: 'inquiries#show'
  get 'privacy_policy', to: 'privacy_policies#show'
  get 'term', to: 'terms#show'

  resource :user, only: %i[new create]
  resource :time_setting, only: %i[edit update]
  resource :route, only: %i[new show]

  resources :password_resets, only: %i[new create edit update]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
