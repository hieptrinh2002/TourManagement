Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users, controllers:
    {registrations: "users/registrations",
      confirmations: "users/confirmations",
      sessions: "users/sessions",
      passwords: "users/passwords",
      unlocks: "users/unlocks",
      omniauth_callbacks: "users/omniauth_callbacks"}

  resources :users, only: %i(new create show) do
    resources :bookings do
      member do
        patch :cancel
      end
    end
  end
  resources :account_activations, only: :edit

  namespace :admin do
    get "/", to: "admin#index"
    resources :tours do
      member do
        #remove_image_admin_tour_path
        delete :remove_image
      end
    end
    resources :vouchers
    resources :bookings, only: %i(index show destroy update)
  end

  resources :tours, only: %i(index show) do
    resources :bookings
    resources :reviews
  end
  root "static_pages#home"

  namespace :api do
    namespace :v1 do
      resources :tours
      resources :users
      post "/sign_in", to: "users#sign_in"
    end
  end
end
