Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "users#index"

  # メール送信テスト（開発環境のみ有効）
  # http://localhost:8888/letter_opener
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :api do
    post :register, to: "users#create", path_names: { create: "register" }
    post :login, to: "authentications#create", path_names: { create: "login" }
    resource :authentication, only: %i[show]
    namespace :password do
      resource :reset, only: %i[create update]
    end
    resource :profile, only: %i[update] do
      resource :password, only: %i[create update]
    end
    resource :user do
      resources :todos
    end
  end
end
