# == Route Map
#

Magaz::Engine.routes.draw do
  
  shallow do
    resources :categories, only: [:edit, :update, :destroy] do
      resources :products, except: :show
    end
  end

  get '/categories/new/(:parent)', to: 'categories#new', as: :new_category
  post '/categories/(:parent)', to: 'categories#create'
  get '/categories/(:parent)', to: 'categories#index', as: :categories


  resources :properties, except: :show do
    resources :property_options, only: [:create, :destroy] do
      member do
        patch :up
        patch :down
      end
    end
  end
end
