# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  authenticate :user, ->(u) { Rails.env.development? && u.admin? } do
    require 'sidekiq/web'

    mount Sidekiq::Web, at: '/sidekiq'
  end

  devise_for :users, skip: :all
  devise_scope :user do
    authenticated :user do
      mount AvatarUserImageUploader.upload_endpoint(:cache) => '/images/upload'
    end

    # Profile user routes
    authenticated :user, ->(u) { u.profile? } do
      root 'profiles#show', as: :profile_root

      resource :profile, except: %i[index create new destroy] do
        get :change_password, on: :collection
        put :update_password, on: :collection
        get :destroy, on: :collection, as: :delete
      end
    end

    # Admin user routes
    authenticated :user, ->(u) { u.admin? } do
      root to: 'admin/dashboard#index', as: :admin_root

      namespace :admin do
        resources :users do
          put :up, on: :member
          put :down, on: :member
          get :upload, on: :collection
          post :import, on: :collection
        end
      end
    end

    delete 'logout', to: 'sessions#destroy'
  end

  # Guest routes
  unauthenticated :auth do
    root 'guest#index'
    post 'login', to: 'sessions#create'
    get 'register', to: 'registrations#new'
    post 'registration', to: 'registrations#create'
    get 'create_password', to: 'registrations#create_password', as: :guest_create_password
    post 'update_password', to: 'registrations#update_password', as: :guest_update_password
  end
end
