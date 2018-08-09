Rails.application.routes.draw do
  root 'hello#index'

  get 'hello/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :videos do
        resources :comments
      end
    end
  end

  post 'signin', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
