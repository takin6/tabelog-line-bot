Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :search_restaurants, only: [:new]

  namespace :api do
    namespace :stations do
      resources :suggests, only: [:index]
    end
    post "/line/callback"
    post "/line/callback_liff"
    post "validate_chat_unit", to: "validate_chat_unit#create"
  end
end
