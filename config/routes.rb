Rails.application.routes.draw do

  devise_scope :user do
    match '/users/finish_signup' => 'users/confirmations#finish_signup', via: [:get, :patch], as: :finish_signup
  end

  devise_for :users, path: 'users', controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions:           'users/sessions',
    registrations:      'users/registrations',
    passwords:          'users/passwords',
    confirmations:      'users/confirmations',
  }

  # translated routes by the route_translator gem
  localized do

    resources :trips, except: [:index, :destroy] do
      member do
        get 'confirm'
        get 'delete'
        get 'resend_confirmation_email'
        get 'resend_information_email'
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
    get 'profile', to: 'profile#show', as: 'profile'
    get 'profile/trips', to: 'profile#trips', as: 'profile_trips'
    get 'profile/alerts', to: 'profile#alerts', as: 'profile_alerts'
    get 'profile/edit', to: 'profile#edit', as: 'edit_profile'
    patch 'profile', to: 'profile#update'

    get "/covoits/:from-:to", to: 'landing#index'
    # get "/covoits/:from", to: 'landing#index'
    resources :user_alerts, except: [:index]
  end

  resources :cities, defaults: { format: :json } do
    collection do
      get 'autocomplete'
      get 'main'
    end
  end

  namespace :admin do
    resources :users do
      put :lock
      delete :lock, to: 'users#unlock'
      post :send_reset_password_mail
      post :send_confirmation_mail
    end
    resources :page_parts
    resources :pages
    resources :stats, only: :index do
      collection do
        get 'trips_count'
        get 'trips_tab'
      end
    end
    root to: 'pages#index'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get "/:id", to: 'pages#show'

  root to: 'home#index'
end
