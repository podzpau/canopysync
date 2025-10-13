Rails.application.routes.draw do
  root 'home#index'
  
  namespace :admin do
    resource :settings, only: [:edit, :update]  # singular 'resource' = no ID needed
    resources :blocks, only: [:create, :edit, :update, :destroy] do
      collection do
        patch :reorder
      end
    end
    get 'preview', to: 'blocks#preview'
  end
end