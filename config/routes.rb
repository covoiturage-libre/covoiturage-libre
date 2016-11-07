Rails.application.routes.draw do

  # translated routes by the route_translator gem
  localized do

    resources :trips, except: [:destroy] do
      member do
        get 'confirm'
        get 'delete'
        get 'resend_email'
        get 'points'
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

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root to: 'home#index'
end
