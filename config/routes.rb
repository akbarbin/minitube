Rails.application.routes.draw do
  root 'hello#index'

  get 'hello/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :videos do
        resources :comments
      end
    end
  end

  post 'signin', to: 'api/v1/authentication#authenticate'
  delete 'signout', to: 'api/v1/authentication#destroy'
  post 'signup', to: 'api/v1/users#create'

  get 'profile', to: 'api/v1/users#profile'
end
