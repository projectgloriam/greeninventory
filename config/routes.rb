Rails.application.routes.draw do

  get '/audit' => 'notifications#index'

  resources :serials
  resources :equipment
  resources :specifications
  
  get "/signout" => "sessions#destroy"

  post "/adauth" => "sessions#create"

  get "/adauth" => "sessions#new"

  resources :sessions

  get 'welcome/index'

  get '/search' => 'equipment#search'

  get '/simplesearch' => 'equipment#simplesearch'

  get '/searchresult' => 'equipment#searchresult'

  get '/tested' => 'equipment#tested'

  #mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
	root 'welcome#index'

  get 'prices', :to => redirect('/fglstocklist.html')

  get 'servicerates', :to => redirect('/itrates.html')

  get 'feedback', :to => redirect('/feedback.html')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
