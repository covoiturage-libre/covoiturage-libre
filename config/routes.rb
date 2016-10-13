Rails.application.routes.draw do

  resources :trips, except: [:destroy] do
    member do
      get 'confirm'
      get 'delete'
    end
    resources :messages
  end

  resources :geocodes do
    collection do
      get 'autocomplete'
    end
  end

  get 'search', to: 'search#index'
  get 'home/index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root to: 'home#index'
end
