# == Route Map
#

Magaz::Engine.routes.draw do

  root to: "dashboard#index"

  get 'dashboard/index'

  devise_for :users, {
    class_name: "Magaz::User",
    module: :devise
  }
  
  as :user do
    get 'profile', to: 'users#edit', as: 'edit_profile'
    patch 'profile', to: 'users#update'
    patch 'update_password', to: 'users#update_password'
  end


  concern :moveable do
    patch :up
    patch :down
  end

  concern :iterable do
    get :next
    get :prev
  end

  concern :image_attachable do
    post :upload
    get :gallery
  end

  concern :valuable do
    get :properties
    post :properties_create
  end

  concern :shiftable do
    post :shift, on: :collection
  end

  shallow do
    resources :categories, only: [:edit, :update, :destroy] do
      concerns :moveable
      resources :products, except: :show do
        concerns [:moveable, :image_attachable, :valuable]
        resources :variants, only: [:index, :new, :create, :destroy, :edit, :update] do
          concerns :moveable
        end
        resources :comments, only: [:index, :edit, :update, :destroy]
      end
    end
  end

  resources :comments, only: :index do
    concerns :shiftable
  end

  resources :products, only: [] do
    concerns [:shiftable, :iterable]
  end

  resources :variants, only: [] do
    concerns :shiftable
  end


  patch '/products/(:product_id)/images/(:image_id)/up', to: 'products#image_up', as: :product_image_up
  patch '/products/(:product_id)/images/(:image_id)/down', to: 'products#image_down', as: :product_image_down
  delete '/products/(:product_id)/images/(:image_id)', to: 'products#image_destroy', as: :product_image_destroy

  get '/products/(:product_id)/descr', to: 'products#descr', as: :product_description

  get '/categories/new/(:parent)', to: 'categories#new', as: :new_category
  post '/categories/(:parent)', to: 'categories#create'
  get '/categories/(:parent)', to: 'categories#index', as: :categories

  get '/categories/(:id)/descr', to: 'categories#descr', as: :category_description
  delete '/categories/:id/image', to: 'categories#image_destroy', as: :category_image_destroy

  shallow do
    resources :property_groups, only: [:edit, :update, :destroy] do
      concerns :moveable
      resources :properties, except: :show do
        concerns :moveable
        resources :property_options, only: [:index, :create, :destroy] do
          concerns :moveable
        end
        resources :property_args, only: [:index, :update]
      end
    end
  end

  get '/properties/(:id)/descr', to: 'properties#descr', as: :property_description
  get '/property_groups/new/(:parent_id)', to: 'property_groups#new', as: :new_property_group
  post '/property_groups/(:parent_id)', to: 'property_groups#create'
  get '/property_groups/(:parent_id)', to: 'property_groups#index', as: :property_groups

  resources :line_items, only: [:destroy]
  
  resources :orders, except: [:show] do
    member do
      get :edit_items
      get :edit_contacts
      get :edit_delivery
      get :edit_payment
      get :edit_status
      patch :recount
    end
  end

  resources :deliveries, except: [:show] do
    concerns :moveable
  end
  resources :payments, except: [:show] do
    concerns :moveable
  end
  resources :statuses, except: [:show] do
    concerns :moveable
  end

  get '/settings', to: 'settings#index', as: :settings
  post '/settings', to: 'settings#update'

  get '/order/:id/bill', to: 'orders#bill', as: :bill

end
