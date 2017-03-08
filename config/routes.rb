Rails.application.routes.draw do
  get 'cart/add'

  get 'session/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"
  resources :users
  get '/users/:id/roles', to: 'users#editrole'
  post '/users/:id/roles', to: 'users#updaterole'
  get '/users/:id/password', to: 'users#editpassword'
  patch '/users/:id/password', to: 'users#updatepassword'
  get '/users/:id/temppass', to: 'users#createtemppassword'
  get '/profile', to: 'users#profile'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :storage_facilities

  resources :animals

  resources :registrations

  resources :inventory_transactions, except: :destroy

  resources :fees

  get '/commissions', to: 'commissions#index'
  post '/users/:user/commission', to: 'commissions#create' #API
  delete '/users/:user/commission', to: 'commissions#destroy' #API

  get '/session/new', to: 'session#new'
  get '/cart/:session/add', to: 'cart#add'
  get '/cart/:session', to: 'cart#show'
  post '/cart/:session', to: 'cart#checkout'

  #errors
  match '/401', to: 'errors#unauthorised', via: :all

end
