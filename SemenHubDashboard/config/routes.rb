Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"
  resources :users

  resources :storage_facilities

  resources :animals

  resources :registrations
  get 'registrations/:id/add_animal', to: 'registrations#add_animal'
  post 'registrations/:id/add_animal', to: 'registrations#add_animal_post'
end
