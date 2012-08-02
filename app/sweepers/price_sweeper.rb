class PriceSweeper < ActionController::Caching::Sweeper
  observe Price
  include SweepersHelper

  def after_create(price)
    expire_cache_for(price)
  end

  private

  def expire_cache_for(price)
    #good
    if price.good
      rm "#{Rails.root}/public/goods/#{price.good.id}.html"
      rm "#{Rails.root}/public/goods/#{price.good.id}/prices.html"
      rm_r "#{Rails.root}/public/goods/#{price.good.id}"
    end

    #cities
    expire_page(:controller => 'cities', :action => 'show', :id => price.city.name) if price.city
    rm "#{Rails.root}/public/cities/#{price.city.name}.html" if price.city
    rm_r "#{Rails.root}/public/cities/#{price.city.name}" if price.city

    #prices
    expire_page(:controller => 'prices', :action => 'index')
    rm_r "#{Rails.root}/public/prices/page"
    rm_r "#{Rails.root}/public/prices/cheapest"
    rm_r "#{Rails.root}/public/prices/groupbuy"
  end
end
