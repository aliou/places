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

# == Route Map
#
#        Prefix Verb   URI Pattern                        Controller#Action
#          root GET    /                                  home#index
#               GET    /auth/:provider/callback(.:format) sessions#create
#  auth_failure GET    /auth/failure(.:format)            sessions#failure
#       signout GET    /signout(.:format)                 sessions#destroy
# import_places GET    /places/import(.:format)           places#import
#        places GET    /places(.:format)                  places#index
#               POST   /places(.:format)                  places#create
#     new_place GET    /places/new(.:format)              places#new
#    edit_place GET    /places/:id/edit(.:format)         places#edit
#         place GET    /places/:id(.:format)              places#show
#               PATCH  /places/:id(.:format)              places#update
#               PUT    /places/:id(.:format)              places#update
#               DELETE /places/:id(.:format)              places#destroy
#
