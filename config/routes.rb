Rails.application.routes.draw do
  root 'admin/settings#edit'
  
  namespace :admin do
    resource :settings, only: [:edit, :update]
    resources :blocks, only: [:create, :edit, :update, :destroy] do
      collection do
        patch :reorder
      end
    end
    get 'preview', to: 'blocks#preview'
  end
end