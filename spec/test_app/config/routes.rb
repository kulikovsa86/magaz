Rails.application.routes.draw do

  mount Magaz::Engine => '/magaz'

  root to: 'products#index'

  controller :products do
    get 'products/:id' => :show, as: 'product'
    post 'products/send_mail' => :send_mail
    post 'products/:id' => :add2cart
  end
  
  get 'cart', to: 'carts#index', as: 'cart'
  delete 'cart', to: 'carts#destroy'
  post 'recount', to: 'carts#recount', as: 'recount'

  get 'order', to: 'carts#new_order', as: 'order'
  post 'order', to: 'carts#create_order'
  
  delete 'item/:id', to: 'carts#delete_item', as: 'item'

end
