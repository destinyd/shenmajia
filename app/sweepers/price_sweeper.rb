class PriceSweeper < ActionController::Caching::Sweeper
  observe Price

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
    rm "#{Rails.root}/public/cities/#{price.city.name}.html" if price.city
    rm_r "#{Rails.root}/public/cities/#{price.city.name}" if price.city

    #prices
    expire_page(:controller => 'prices', :action => 'index')
    rm_r "#{Rails.root}/public/prices/page"
    rm_r "#{Rails.root}/public/prices/cheapest"
    rm_r "#{Rails.root}/public/prices/groupbuy"
  end

  def rm(dir)
    File.delete dir if File.exist?(dir)
  end

  def rm_r(dir)
    FileUtils.rm_r dir if File.exist?(dir)
  end
end
