Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :events, only: %i[create show index update destroy] do
        member do
          put :publish
        end
      end
      resources :users, only: %i[create show index] do
        resources :events, only: %i[create index], controller: 'users/events'
      end
    end
  end
end
