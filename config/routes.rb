Rails.application.routes.draw do

  # translated routes by the route_translator gem
  localized do

    resources :trips, except: [:destroy] do
      member do
        get 'confirm'
        get 'delete'
        get 'resend_email'
        get 'new_from_copy'
        get 'new_for_back'
        get 'points'
        get 'phone_number_image'
      end
      resources :messages
    end
    get 'search', to: 'search#index'

    PagesController::STATIC_PAGES.each do |page|
      get page, to: "pages##{page}"
    end

  end

  resources :geonames do
    collection do
      get 'autocomplete'
    end
  end

  namespace :admin do
    resources :page_parts
    root to: 'page_parts#index'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "text/:text" => Dragonfly.app.endpoint { |params, app|
    app.generate(:text, params[:text], 'font-size': 14)
  }

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  root to: 'home#index'
end
