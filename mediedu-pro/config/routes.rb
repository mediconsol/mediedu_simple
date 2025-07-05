Rails.application.routes.draw do
  # Root route
  root "home#index"
  
  # Resources
  resources :quizzes, only: [:index, :show] do
    member do
      post :attempt
      patch :attempt
      patch :next_question
      get :result
    end
  end
  
  resources :documents, only: [:index, :show, :new, :create] do
    resources :quizzes, only: [:new, :create]
  end
  
  resources :quiz_attempts, only: [:create, :update]
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes (optional)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
