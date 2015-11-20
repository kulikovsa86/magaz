# == Route Map
#

Magaz::Engine.routes.draw do
  
  concern :moveable do
    patch :up
    patch :down
  end

  concern :image_attachable do
    post :upload
    get :gallery
  end

  concern :valuable do
    get :properties
    post :properties_create
  end

  shallow do
    resources :categories, only: [:edit, :update, :destroy] do
      concerns :moveable
      resources :products, except: :show do
        concerns [:moveable, :image_attachable, :valuable]
        resources :variants, only: [:index, :new, :create, :destroy] do
        end
      end
    end
  end

  patch '/products/(:product_id)/images/(:image_id)/up', to: 'products#image_up', as: :product_image_up
  patch '/products/(:product_id)/images/(:image_id)/down', to: 'products#image_down', as: :product_image_down
  delete '/products/(:product_id)/images/(:image_id)', to: 'products#image_destroy', as: :product_image_destroy

  get '/categories/new/(:parent)', to: 'categories#new', as: :new_category
  post '/categories/(:parent)', to: 'categories#create'
  get '/categories/(:parent)', to: 'categories#index', as: :categories

  shallow do
    resources :properties, except: :show do
      resources :property_options, only: [:create, :destroy] do
        concerns :moveable
      end
    end
  end

  resources :line_items, only: [:create, :destroy]
  
  resources :orders, except: [:show]

  resources :deliveries, except: [:show]
  resources :payments, except: [:show]

end
