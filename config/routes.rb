Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :products, only: [:show]
    resources :orders, only: [:new, :create]
    namespace :admin do
      root "static_pages#index"
      resources :orders, only: [:index, :edit, :update]
      resources :products
    end

    resources :carts, only: [:index] do
      collection do
        get "/add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
        get "remove/:id", to: "carts#remove_from_cart", as: "remove_from"
        put "update_cart/:id", to: "carts#update_cart", as: "update"
      end
    end

  end
end
