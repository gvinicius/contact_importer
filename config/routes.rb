Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'imports', to: 'imports#create', defaults: { format: 'json' }
      get 'imports', to: 'imports#index', defaults: { format: 'json' }
    end
  end

  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'home#index'
  get 'service-worker(.format)', to: 'home#service_worker'
end
