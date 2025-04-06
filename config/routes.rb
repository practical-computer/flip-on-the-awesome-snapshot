# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, sign_out_via: [:get, :delete]

  constraints(subdomain: "admin") do
    devise_for :administrators, path: :administrator, controllers: {
      sessions: 'administrator/sessions'
    }, sign_out_via: [:get, :delete]

    devise_scope :administrator do
      namespace :administrator do
        post 'sign_in/new_challenge', to: 'sessions#new_challenge', as: :new_session_challenge

        resources :emergency_passkey_registrations, only: [:new, :create, :show] do
          member do
            patch :use
            post :new_challenge
          end
        end
      end

      authenticated :administrator do
        mount Flipper::UI.app(Flipper) => '/flipper'
        mount GoodJob::Engine => 'good_job'
        root to: "admin/organizations#index", as: :admin_root

        namespace(:admin) do
          resources :organizations
          namespace(:organization) do
            resources :attachments
            resources :jobs
            resources :notes
                  end

          resources :users
          namespace(:user) do
            resources :emergency_passkey_registrations
            resources :passkeys
          end

          namespace(:utility) do
            resources :ip_addresses
            resources :user_agents
          end

          resources :google_places
          resources :memberships
          resources :membership_invitations
        end
      end
    end

    get '/manifest.webmanifest' => "web_manifest#admin_manifest", as: :admin_web_manifest

    match '/*glob', to: redirect('/404'), via: :all
  end

  devise_scope :user do
    post 'sign_up/new_challenge', to: 'users/registrations#new_challenge', as: :new_user_registration_challenge
    post 'sign_in/new_challenge', to: 'users/sessions#new_challenge', as: :new_user_session_challenge

    authenticated(:user) do
      post('reauthenticate/new_challenge', to: 'users/reauthentication#new_challenge',
                                           as: :new_user_reauthentication_challenge
          )
      post 'reauthenticate', to: 'users/reauthentication#reauthenticate', as: :user_reauthentication
    end

    namespace :users, as: :user do
      get 'emergency_login/:id', to: 'sessions#emergency_login', as: :emergency_login

      authenticated(:user) do
        resources :passkeys, only: [:create, :destroy] do
          collection do
            post :new_create_challenge
          end

          member do
            post :new_destroy_challenge
          end
        end

        patch :update_theme, to: "theme#update"

        resources :memberships, only: [:index, :update]
        delete "membership_invitations/:id", to: "membership_invitations#destroy", as: :hide_membership_invitation
      end

      resources :emergency_passkey_registrations, only: [:new, :create, :show] do
        member do
          patch :use
          post :new_challenge
        end
      end
    end
  end

  resources :membership_invitations, only: [:show] do
    member do
      post :new_create_challenge
      post :create_user_and_use
      delete :sign_out_then_show

      authenticated(:user) do
        patch :accept_as_current_user
      end
    end
  end

  resources :organizations, only: [:index, :show] do
    scope module: 'organizations' do
      resources :membership_invitations, only: [:destroy] do
        member do
          patch :resend
        end
      end
      resources :memberships, only: [:index, :create, :edit, :update, :destroy]

      resources :attachments, only: [:create]

      resources :jobs do
        resources :onsites, shallow: true, shallow_path: "/organizations/:organization_id", except: [:index, :destroy]
        resources :tasks, controller: "job_tasks", only: [:new, :create]
        resources(:job_tasks,
                  shallow: true,
                  shallow_path: "/organizations/:organization_id",
                  except: [:index, :new, :create]
                )
      end

      resources :notes, except: [:new]
      resources :notes, only: [:new], path: "/notes/:resource_gid"
    end
  end

  constraints(subdomain: "readonly") do
    scope module: 'readonly' do
      resources :onsites, only: [:show], as: :readonly_onsite
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "organizations#index"

  get "/application_health/boot" => "application_health#show"
  get "/application_health/db" => "application_health#db"
  get "/application_health/wafris" => "application_health#wafris"

  get '/manifest.webmanifest' => "web_manifest#manifest", as: :web_manifest
end
