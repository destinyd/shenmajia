class GoodSweeper < ActionController::Caching::Sweeper
  observe Good

  def after_create(good)
    expire_cache_for(good) if good.id % 10 == 0
  end
 
  # If our sweeper detects that a good was updated call this
  #def after_update(good)
    #expire_cache_for(good)
    #expire_cache_for_single(good)
  #end
 
  # If our sweeper detects that a good was deleted call this
  #def after_destroy(good)
    #expire_cache_for(good)
    #expire_cache_for_single(good)
  #end

  private
  def expire_cache_for(good)
    expire_page(controller: 'goods', action: 'index')
    #expire_page '/goods.html'
    
    # manually remove pages(1.html, 2.html, etc)
    FileUtils.rm_r "#{Rails.root}/public/goods/page" if File.exist?("#{Rails.root}/public/goods/page")
  end
end
