Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "users#index"

  namespace "api" do
    post "register", to: "users#create"
    get "register_completion", to: "users#email_confirm"
    post "login", to: "authentication#login"
    resources :users, only: [:update] do
      resources :todos
      put "password_update", to: "users#update_password"
      namespace "password" do
        post "forgot", to: "passwords#forgot"
        post "reset", to: "passwords#reset"
      end
    end
  end
end
