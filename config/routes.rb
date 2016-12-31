Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # translated routes by the route_translator gem
  localized do

    resources :trips, except: [:index, :destroy] do
      member do
        get 'confirm'
        get 'delete'
        get 'resend_email'
        get 'new_from_copy'
        get 'new_for_back'
        get 'points'
        get 'phone_number_image'
        get 'confirm_delete'
      end
      resource :phone, only: :show, controller: 'trips/phones'
      resources :messages
    end
    get 'search', to: 'search#index'

    get "/covoits/:from-:to", to: 'landing#index'
    #get "/covoits/:from", to: 'landing#index'

  end

  resources :cities do
    collection do
      get 'autocomplete'
    end
  end

  namespace :admin do
    resources :page_parts
    resources :pages
    resources :stats
    root to: 'pages#index'
  end
  mount Searchjoy::Engine, at: "admin/searchjoy"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get "/:id", to: 'pages#show'

  root to: 'home#index'
end
