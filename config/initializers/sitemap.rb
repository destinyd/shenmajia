DynamicSitemaps::Sitemap.draw do
  
  # default per_page is 50.000 which is the specified maximum.
  per_page 500

  #url root_url,
#:last_mod => Price.last.created_at,
    #:change_freq => 'daily', :priority => 0.8
  ##new_page!

  url bills_url, 
:last_mod => Bill.last.created_at,
 :change_freq => 'daily', :priority => 0.6

  url costs_url, 
:last_mod => Cost.last.created_at,
 :change_freq => 'daily', :priority => 0.6

  url places_url, 
:last_mod => Place.last.created_at,
 :change_freq => 'daily', :priority => 0.5
  #url costs_prices_url, 
  #url costs_prices_url, 
  url prices_url, 
:last_mod => Price.last.created_at,
 :change_freq => 'daily', :priority => 0.4
  #url costs_prices_url, 
#:last_mod => Price.last.created_at,
 #:change_freq => 'daily', :priority => 0.6
  url cheapest_prices_url, 
:last_mod => Price.last.created_at,
 :change_freq => 'daily', :priority => 0.4
  url groupbuy_prices_url, 
:last_mod => Price.last.created_at,
 :change_freq => 'daily', :priority => 0.4

  url tags_goods_url, 
:last_mod => Good.last.created_at,
 :change_freq => 'daily', :priority => 0.2

  url goods_url, 
:last_mod => Good.last.created_at,
 :change_freq => 'daily', :priority => 0.4

  url cities_url, 
:last_mod => City.order(:updated_at).last.updated_at,
 :change_freq => 'monthly', :priority => 0.1

  #new_page!
  
  #Price.all.each do |price|
    #url price_url(price), 
#:last_mod => price.updated_at,
 #:change_freq => 'monthly', :priority => 0.7
  #end
  #new_page!
  
  #autogenerate  :prices,# :goods,
                #
#:last_mod => :updated_at,

                #:change_freq => 'monthly',
                #:priority => 0.5
  #new_page!
  
end
