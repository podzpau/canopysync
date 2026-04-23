Rails.application.routes.draw do
  root "admin/dashboard#show"

  namespace :admin do
    get "/", to: "dashboard#show", as: :dashboard
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

    resource :settings, only: [ :edit, :update ] do
      collection do
        get :preview
        get :preview_full
        post :publish
      end
    end
    resources :blocks, only: [ :create, :destroy ] do
      collection do
        post :reorder
        delete :delete
      end
    end

    # SEO Overview + per-record editors
    resources :seo, only: [ :index ] do
      collection do
        get :products
        get :brands
        get :collections
      end
    end
    get  "seo/product/:id/edit",  to: "seo#edit_product",     as: :edit_product_seo
    patch "seo/product/:id",      to: "seo#update_product",   as: :update_product_seo
    get  "seo/brand/:id/edit",    to: "seo#edit_brand",       as: :edit_brand_seo
    patch "seo/brand/:id",        to: "seo#update_brand",     as: :update_brand_seo
    get  "seo/collection/:id/edit", to: "seo#edit_collection", as: :edit_collection_seo
    patch "seo/collection/:id",   to: "seo#update_collection", as: :update_collection_seo

    # Global SEO settings
    resource :seo_settings, only: [ :edit, :update ]

    # Concept entity management
    resources :concept_entities, path: "seo/entities"

    # Redirect manager
    resources :redirects, path: "seo/redirects"
  end

  # Storefront (public, resolved by shop's custom domain)
  get "strains/",       to: "storefront/strains#index", as: :storefront_strains
  get "strains/:slug/", to: "storefront/strains#show",  as: :storefront_strain
  get "product/:slug", to: "storefront/products#show", as: :storefront_product
  get "collection/*path", to: "storefront/collections#show", as: :storefront_collection
  get "brand/:slug", to: "storefront/brands#show", as: :storefront_brand

  # Sitemaps
  get "sitemap.xml", to: "storefront/sitemaps#index", defaults: { format: :xml }, as: :storefront_sitemap_index
  get "sitemap-products(-:page).xml", to: "storefront/sitemaps#products", defaults: { format: :xml }, as: :storefront_sitemap_products
  get "sitemap-collections.xml", to: "storefront/sitemaps#collections", defaults: { format: :xml }, as: :storefront_sitemap_collections
  get "sitemap-brands.xml", to: "storefront/sitemaps#brands", defaults: { format: :xml }, as: :storefront_sitemap_brands
  get "sitemap-images.xml",  to: "storefront/sitemaps#images",  defaults: { format: :xml }, as: :storefront_sitemap_images
  get "sitemap-strains.xml", to: "storefront/sitemaps#strains", defaults: { format: :xml }, as: :storefront_sitemap_strains
  get "sitemap", to: "storefront/sitemaps#html_sitemap", as: :storefront_html_sitemap

  # Robots
  get "robots.txt", to: "storefront/robots#show", defaults: { format: :text }, as: :storefront_robots
end