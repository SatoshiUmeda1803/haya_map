Rails.application.routes.draw do
  get 'routes/new'
  get 'routes/create'
  get 'maps/new'
  root to: 'top_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create]
  resources :routes, only: %i[new index]
end
