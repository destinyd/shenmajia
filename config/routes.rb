Zhekou::Application.routes.draw do
  use_doorkeeper
  namespace :api do
    namespace :v1 do
      # another api routes
      get '/me' => "credentials#me"
      get '/dashboard' => "credentials#dashboard"
      post '/reg' => "registrations#create"
      resources :bills,except: [:edit,:update,:new]
      resources :costs,except: [:edit,:update,:new]
      resources :goods,except: [:edit,:update,:new,:destroy] do
        match :search,on: :collection
      end
    end
  end
  devise_for :users

  @prices = lambda{
    resources :prices,only: [:index,:show,:new,:create] do
      collection do
        get :cheapest
        get :groupbuy
        get :costs
      end
      member do
        #get :buy_one
        #get :near_groupbuy
        #get :near_cheapest
        #get :cheap
      end

      resources :comments
      resources :reviews
      resources :uploads
    end
  }
  @prices.call

  @index_page = lambda{ |controller_name,action_name = 'index'|
    #resources controllers.to_sym,only: :index,page: 1
    get "/#{controller_name}#{'/'+action_name unless ['index','show'].include? action_name}(/page/:page)" => "#{controller_name}##{action_name}", constraints: {
      page: /[2-9]|\d{2,}/
    },default:{page:1},as: controller_name.to_sym
  }

  root to:  "home#index"
  match "/:reviewable_type/:reviewable_id/reviews" => "reviews#:action",as: 'reviewable'
  #match "/:locatable_type/:locatable_id" => ":locatable_type#show",id:  :locatable_id,as: 'locatable'

  %w{groupbuy cheapest}.each do |p|
    get "/prices/#{p}/page/:page" => "prices##{p}"
    get "/cities/:city_id/prices/#{p}/page/:page" => "prices##{p}"
  end

  resources :carts, only: [:index]
  
  #resources :products

  resources :bills, except: [:edit] do
    resources :comments
    resources :costs, only: :index
  end

  #resources :orders, except: [:edit,:update] do
    #resources :comments
  #end

  resources :costs, except: [:edit,:update] do
    resources :comments
  end

  resources :norms,only:  :index
  resources :units,only:  :index

  #resources :brands do
    #resources :products
    ##resources :norms
    ##resources :units
  #end

  #resources :companies

  namespace :userhome do
    resources :homes
    #resources :prices
    resources :costs,only: [:index]
    resources :bills,only: [:index,:destroy]
    resources :orders,only: [:index,:show,:destroy,:update] do
      post :receive,on: :member
      post :cancel,on: :member
    end

    root to:  "homes#index"
    #match 'costs' => 'homes#costs'
    match 'integrals' => 'homes#integrals'
    #resources :shops,only: [:index,:edit,:update] do
    #end
  end

  scope '/userhome' do 
    resources :contacts do
      post :set_default, on:  :member
    end
  end

  namespace :shop do
    resources :orders,only: [:index,:show,:destroy,:update] do
      post :pay,on: :member
      post :cancel,on: :member
    end
    resources :inventories,except: [:show]
    resources :shops,only: [:index,:edit]
    resources :shop_contacts
    root to:  "homes#index"
    get 'edit' => "homes#edit"
  end


  resources :orders, only: [:create]#, path:'/userhome/orders'
  #resources :orders, only: [:create] do
    #resources :comments
  #end

  resources :shops do
    resources :inventories
    resources :bills, except: [:edit,:update]
    resources :orders, except: [:edit,:update]
    #@page.call 'shops#show'
    #resources :shop_carts, only: [:index,:update,:create,:destroy]
  end

  resources :shop_carts, only: [:index,:update,:create,:destroy]

  resources :inventories, except: [:index] do
    resources :comments
    collection do
      match :search#, on:  :collection
      #get :tuijian#,on
    end
  end
  match "/inventories/search/page/:page" => "inventories#search"

  #match 'sitemap.xml' => 'sitemaps#sitemap'

  resources :locates,only: [:create,:new] do
  end

  resources :cities,only: [:index] do
    @prices.call
    #get 'inventories/tuijian' => 'inventories#tuijian'
    resources :shops
    #resources :prices,only: :index#,page: 1
    get :search, on:  :collection    
  end

  get '/cities/:id(/page/:page)' => 'cities#show', constraints: {
      page: /[2-9]|\d{2,}/
    },default:{page:1},as: :city



  #match '/prices/local' => redirect('/prices/costs')
  #resources :user_infos

  #resources :my_tasks

  #resources :user_tasks

  #resources :tasks

  #resources :price_goods

  resources :reviews
  resources :attrs,only: [:new] do
    resources :reviews
  end

  resources :flashes

  resources :articles do
    resources :comments
    resources :reviews
  end

  resources :outlinks do
    resources :reviews
  end

  resources :focus

  resources :goods do
    #resources :costs, only:  :index

    resources :comments
    resources :uploads
    resources :reviews
    @prices.call
    #resources :prices,only: [:index,:show,:new,:create] do
      #collection do
        #get :cheapest
        #get :groupbuy
        #get :local
      #end
    #end

    resources :focus
    resources :outlinks
    resources :attrs,only: [:index,:show,:create,:new] do
      resources :reviews
    end
    collection do
      get :tags
      get :search
    end
    member do
      get :tag
    end
  end

  get "home/index"

  resources :uploads do#,only: [:show]
    resources :comments
  end

  #devise_for :users#     , controllers: { sessions:  "users/sessions" }
  #  devise_scope :user do
  #    get "sign_out", to:  "users/sessions#destroy"
  #  end

  #  get '/users/sign_out(.:format)',to: 'users/sessions#destroy'

  #resources :records

  resources :msgs do
    get :sents, on: :collection
  end



end
