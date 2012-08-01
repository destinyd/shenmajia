class PriceSweeper < ActionController::Caching::Sweeper
  observe Price

  def after_create(price)
    expire_cache_for(price) if price.id % 10 == 0
    expire_cache_for_belongs_to(price)
  end

  private
  def expire_cache_for_belongs_to(price)
    expire_cache_for_other(price.good) unless price.good
  end

  def expire_cache_for_other(obj)
    p = "/#{obj.class.name.downcase.pluralize}/#{obj.id}"
    expire_page(p)
  end

  def expire_cache_for(price)
    expire_page(:controller => 'prices', :action => 'index')
    expire_page(:controller => 'prices', :action => 'index',:good_id => price.good.id) if price.good
    expire_page(:controller => 'prices', :action => 'index',:city_id => price.city.name) if price.city
    #expire_page(:controller => 'cities', :action => 'show')
    
    File.delete "#{Rails.root}/public/goods/#{price.good.id}/prices.html" if price.good and File.exist?("#{Rails.root}/public/goods/#{price.good.id}/prices.html")
    File.delete "#{Rails.root}/public/cities/#{price.city.name}/prices.html" if price.city and File.exist?("#{Rails.root}/public/cities/#{price.city.name}/prices.html")

    FileUtils.rm_r "#{Rails.root}/public/goods/#{price.good.id}/prices" if price.good and File.exist?("#{Rails.root}/public/goods/#{price.good.id}/prices")
    FileUtils.rm_r "#{Rails.root}/public/cities/#{price.city.name}/prices" if price.city and File.exist?("#{Rails.root}/public/cities/#{price.city.name}/prices")
    FileUtils.rm_r "#{Rails.root}/public/prices/page" if File.exist?("#{Rails.root}/public/prices/page")
  end
end
