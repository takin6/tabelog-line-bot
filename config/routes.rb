Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :search_restaurants, only: [:new]

  namespace :api do
    post "/line/callback"
    post "/line/callback_liff"
    post "validate_user", to: "validate_user#create"
  end
end
