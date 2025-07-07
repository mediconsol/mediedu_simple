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
  get "health" => "rails/health#show"
  
  # Simple ping endpoint for Railway
  get "ping", to: proc { [200, {}, ["pong"]] }
  get "hello", to: proc { [200, {}, ["Hello Railway! Rails is running on port #{ENV['PORT'] || 3000}"]] }

  # PWA routes (optional)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
