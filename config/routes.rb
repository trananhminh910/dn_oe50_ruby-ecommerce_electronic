Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/show_buy_history/:id", to: "users#show_buy_history", as: "buy_history"
    get "/show_buy_history_details/:order_id", to: "users#show_buy_history_details", as: "buy_history_details"
    get "/cancel_order_user/:order_id", to: "users#cancel_order", as: "cancel_order"
    resources :products, only: [:show]
    namespace :admin do
      root "static_pages#index"
      resources :orders, only: [:index, :edit, :update]
      resources :products
    end

    resources :carts, only: [:index] do
      collection do
        get "/add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
      end
    end
  end
end
