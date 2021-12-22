Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    devise_for :users
    as :user do
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end
    resources :products, only: [:show]
    resources :orders, only: [:new, :create]
    namespace :admin do
      root "static_pages#index"
      resources :orders, only: [:index, :edit, :update]
      resources :products
      get :order_status, to: "static_pages#order_status"
      get :order_total_money_month, to: "static_pages#order_total_money_month"
      get :order_total_money_quarter, to: "static_pages#order_total_money_quarter"
      get :order_total_money_year, to: "static_pages#order_total_money_year"
      get :order_accept_month, to: "static_pages#order_accept_month"
      get :order_accept_quarter, to: "static_pages#order_accept_quarter"
      get :order_accept_year, to: "static_pages#order_accept_year"
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
