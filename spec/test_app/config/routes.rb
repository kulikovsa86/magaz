Rails.application.routes.draw do

  mount Magaz::Engine => "/magaz"

  root to: "products#index"

  controller :products do
    get "products/:id" => :show, as: "product"
    post "products/:id" => :add2cart
  end
  
  get "cart", to: "carts#index", as: "cart"
  delete "cart", to: "carts#destroy"

end
