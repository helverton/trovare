Rails.application.routes.draw do
  resources :reservas
  resources :profissional_servicos
  resources :lista_precos
  resources :servicos
  resources :horarios
  resources :users
  resources :profissionals
  resources :entidade_horarios
  resources :entidades
  resources :ramos
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'


  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'

  put '/:reserva_id/encerrar' => 'reservas#encerrar'

  scope '/api', constraints: { format: :json } do
    get '/profissionais/:servico_id' => 'profissional_servicos#filter'

    get '/:cidade/servicos' => 'servicos#servicos'
    get '/:servico/cidades' => 'entidades#cidades'
    get '/:servico/:cidade/prestadores' => 'entidades#prestadores'

    get '/:entidade_id/:servico_id/profissionais' => 'entidades#profissionais'

    get '/:entidade_id/:data/:servico_id/:profissional_id/horarios' => 'reservas#horarios'

    get '/:data/:lista_preco_id/:profissional_id' => 'reservas#disp'    

    get '/reservas' => 'reservas#reservas'

    post '/reservas/:entidade_id/:data/:hora_inicio/:servico_id/:profissional_id/:telefone/nova' => 'reservas#nova'

    put '/:nota/:reserva_id/avaliar' => 'reservas#avaliar'
  end
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
