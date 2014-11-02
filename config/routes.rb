Rails.application.routes.draw do
  root 'home#index'

  # Omniauth callbacks.
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure',            to: 'sessions#failure'

  # User actions.
  get '/signout',                 to: 'sessions#destroy', as: :signout

  resources :places do
    collection do
      get :import
    end
  end

end
