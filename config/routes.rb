Rails.application.routes.draw do
  root 'admin/settings#edit'
  
  namespace :admin do
    resource :settings, only: [:edit, :update] do
      collection do
        get :preview
      end
    end
    resources :blocks, only: [:create, :destroy, :update] do
      member do
        patch :reorder
      end
    end
  end
end