Zhekou::Application.routes.draw do
  #resources :carts

  get '/users/status' => "users/Status#index", :as => :user_status

  resources :places, :except => [:edit,:update,:destroy] do
    resources :costs, :only => :index
    get 'search' ,:on => :collection
    #match '/search/:q/page/:page' => 'places#search', :on => :collection,:as => :search
  end

  resources :products
  resources :costs, :except => [:edit,:update] do
    resources :comments
  end

  @prices = lambda{
    resources :prices,:only => [:index,:show,:new,:create] do
      collection do
        get :cheapest
        get :groupbuy
        get :costs
      end
      member do
        #get :buy_one
        get :near_groupbuy
        get :near_cheapest
        get :cheap
      end

      resources :comments
      resources :reviews
      resources :uploads
    end
  }
  @prices.call

  %w{place cost good price}.each do |p|
    get "/#{p}s/page/:page" => "#{p}s#index"
    get "/#{p}s/:#{p}_id/costs/page/:page" => "costs#index" if %w{place good}.include?(p)
  end

  %w{groupbuy cheapest}.each do |p|
    get "/prices/#{p}/page/:page" => "prices##{p}"
  end

  %w{groupbuy cheapest}.each do |p|
    get "/cities/:city_id/prices/#{p}/page/:page" => "prices##{p}"
  end

  get "/goods/:good_id/prices/page/:page" => "prices#index"

  #%w{prices goods costs places}.each do |p|
    #match "/#{p}", :to=> redirect{|params,req| "/#{p}/page/#{req.params[:page] || 1}"}
  #end

  resources :norms,:only => :index
  resources :units,:only => :index

  resources :brands do
    resources :products
    #resources :norms
    #resources :units
  end

  resources :companies

  namespace :userhome do
    resources :homes
    #resources :prices
    resources :shops
    resources :costs
    root :to => "homes#index"
    #match 'costs' => 'homes#costs'
    match 'integrals' => 'homes#integrals'
  end

  resources :shops
  match 'sitemap.xml' => 'sitemaps#sitemap'

  resources :locates,:only => [:index,:show,:create,:new] do
  end

  resources :cities,:only => [:index,:show] do
    @prices.call
    resources :shops
  end


  #match '/prices/local' => redirect('/prices/costs')
  resources :user_infos

  resources :my_tasks

  resources :user_tasks

  resources :tasks

  resources :price_goods

  resources :reviews
  resources :attrs,:only => [:new] do
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
    resources :costs, :only => :index

    resources :comments
    resources :uploads
    resources :reviews
    @prices.call
    #resources :prices,:only => [:index,:show,:new,:create] do
      #collection do
        #get :cheapest
        #get :groupbuy
        #get :local
      #end
    #end

    resources :focus
    resources :outlinks
    resources :attrs,:only => [:index,:show,:create,:new] do
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

  resources :uploads#,:only  =>  [:show]

  devise_for :users     , :controllers => { :sessions => "users/sessions" }
  #  devise_scope :user do
  #    get "sign_out", :to => "users/sessions#destroy"
  #  end

  #  get '/users/sign_out(.:format)',:to => 'users/sessions#destroy'

  resources :records

  resources :msgs



  root :to => "home#index"
  match "/:reviewable_type/:reviewable_id/reviews" => "reviews#:action",:as => 'reviewable'
  #match "/:locatable_type/:locatable_id" => ":locatable_type#show",:id => :locatable_id,:as => 'locatable'

  #  match "/users/sign_out(.:format)",:controller => 'users/sessions',:action => :destroy,:as => 'destroy_user_session'

end
