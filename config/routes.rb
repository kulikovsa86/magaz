# == Route Map
#

Magaz::Engine.routes.draw do
  
  concern :moveable do
    patch :up
    patch :down
  end

  concern :imageable do
    post :upload
    get :gallery
  end

  shallow do
    resources :categories, only: [:edit, :update, :destroy] do
      concerns :moveable
      resources :products, except: :show do
        concerns [:moveable, :imageable]
        resources :variants, only: [:index, :new, :create, :destroy] do
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
        concerns :moveable
      end
    end
  end

end
