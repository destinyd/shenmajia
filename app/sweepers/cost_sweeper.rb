class CostSweeper < ActionController::Caching::Sweeper
  observe Cost

  def after_create(cost)
    expire_cache_for(cost) if cost.id % 10 == 0
    expire_cache_for_belongs_to(cost)
  end
 
  # If our sweeper detects that a cost was updated call this
  #def after_update(cost)
    #expire_cache_for(cost)
    #expire_cache_for_single(cost)
  #end
 
  # If our sweeper detects that a cost was deleted call this
  #def after_destroy(cost)
    #expire_cache_for(cost)
    #expire_cache_for_single(cost)
  #end
  private
  def expire_cache_for_belongs_to(cost)
    expire_cache_for_other(cost.locatable) unless cost.locatable.blank?
    expire_cache_for_other(cost.good) unless cost.good.blank?
    #expire_cache_for_other(cost.price) unless cost.price.blank?
  end

  def expire_cache_for_other(obj)
    p = "/#{obj.class.name.downcase.pluralize}/#{obj.id}"
    expire_page(p)
    expire_cache_for_obj_costs(p)
  end

  def expire_cache_for_obj_costs(dir)
    p="#{Rails.root}/public#{dir}"
    FileUtils.rm_r p if File.exist? p
  end

  #def expire_cache_for_single(cost)
    #expire_page(:controller => 'costs', :action => 'show')
  #end
  
  def expire_cache_for(cost)
    expire_page(:controller => 'costs', :action => 'index')

    FileUtils.rm_r "#{Rails.root}/public/costs/page" if File.exist?("#{Rails.root}/public/costs/page")

  end
end
