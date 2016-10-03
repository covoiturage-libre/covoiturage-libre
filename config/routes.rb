Rails.application.routes.draw do

  resources :trips

  resources :geocodes do
    collection do
      get 'autocomplete'
    end
  end

  get 'search', to: 'search#index'
  get 'home/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
