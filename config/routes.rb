Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/cart", to: "static_page#cart"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :products, only: [:show]
    namespace :admin do
      root "static_pages#index"
      resources :orders, only: [:index, :edit, :update]
      resources :products, only: [:index]
    end
  end
end
