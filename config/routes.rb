Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/cart", to: "static_page#cart"
    get "/detail", to: "static_page#detail"
  end
end
