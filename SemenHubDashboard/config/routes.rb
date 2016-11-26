Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"
  resources :users

  resources :storage_facilities

  resources :animals

  resources :registrations

  resources :inventory_transactions, except: :destroy

  get '/commissions', to: 'commissions#index'
  post '/users/:user/commission', to: 'commissions#create' #API
end
