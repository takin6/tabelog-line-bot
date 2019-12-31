Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  devise_scope :user do 
    delete 'user/auth/logout', to: 'omniauth_callbacks#destroy'
  end

  root to: "search_restaurants#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :search_restaurants, only: [:new]
  resources :restaurant_data_sets, only: %i[index new]
  get "/restaurant_data_sets/:cache_id", to: "restaurant_data_sets#show"
  get "/restaurant_data_sets/:restaurant_data_set_id/complete", to: "restaurant_data_sets#create"

  namespace :api do
    namespace :stations do
      resources :suggests, only: [:index]
    end
    post "/line/callback"
    post "/line/callback_liff"
    post "validate_chat_unit", to: "validate_chat_unit#create"
    resources :custom_restaurants, only: [:create]
    resources :restaurant_data_sets, only: [:create]
  end
end
