# == Route Map
#

Magaz::Engine.routes.draw do
  
  concern :movable do
    patch :up
    patch :down
  end

  shallow do
    resources :categories, only: [:edit, :update, :destroy] do
      concerns :movable
      resources :products, except: :show do
        concerns :movable
        resources :variants, except: [:index, :show] do
        end
      end
    end
  end

  get '/categories/new/(:parent)', to: 'categories#new', as: :new_category
  post '/categories/(:parent)', to: 'categories#create'
  get '/categories/(:parent)', to: 'categories#index', as: :categories


  shallow do
    resources :properties, except: :show do
      resources :property_options, only: [:create, :destroy] do
        concerns :movable
      end
    end
  end

end
