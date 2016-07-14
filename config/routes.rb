Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :incoming do
        resources :nexmo, only: %i(create)
      end
    end
  end

  resources :questions

  resources :questions do
    patch "archive"
  end

  resources :outcomes

  root 'questions#index'
end
