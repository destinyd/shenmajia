class CostSweeper < ActionController::Caching::Sweeper
  observe Cost
  include SweepersHelper

  def after_create(cost)
    expire_cache_for(cost)
    #expire_cache_for_belongs_to(cost)
  end
 
  # If our sweeper detects that a cost was updated call this
  def after_update(cost)
    expire_cache_for(cost)
    expire_cache_for_single(cost)
  end
 
  # If our sweeper detects that a cost was deleted call this
  #def after_destroy(cost)
    #expire_cache_for(cost)
    #expire_cache_for_single(cost)
  #end
  private
  #def expire_cache_for_single(cost)
    #expire_page(controller: 'costs', action: 'show')
  #end
  #def expire_cache_for_belongs_to(cost)
    #expire_cache_for_other(cost.locatable) unless cost.locatable.blank?
    #expire_cache_for_other(cost.good) unless cost.good.blank?
    ##expire_cache_for_other(cost.price) unless cost.price.blank?
  #end

  def expire_cache_for_other(obj)
    p = "/#{obj.class.name.downcase.pluralize}/#{obj.id}"
    expire_page(p)
    expire_cache_for_obj_costs(p)
  end

  def expire_cache_for_obj_costs(dir)
    if !dir.blank? and dir.length > 2
      p="#{Rails.root}/public#{dir}"
      FileUtils.rm_r p if File.exist? p
    end
  end
  
  def expire_cache_for(cost)
    expire_page(controller: 'costs', action: 'index')  if cost.id % 10 == 0

    expire_cache_for_other(cost.locatable) unless cost.locatable.blank?
    # expire_cache_for_other(cost.good) unless cost.good.blank?

    #good
    # if cost.good
    #   rm "#{Rails.root}/public/goods/#{cost.good.id}.html"
    #   rm_r "#{Rails.root}/public/goods/#{cost.good.id}"
    # end

    #cities
    rm "#{Rails.root}/public/cities/#{cost.locatable.city.name}.html" if cost.locatable.city
    rm_r "#{Rails.root}/public/cities/#{cost.locatable.city.name}" if cost.locatable.city

    if cost.id % 10 == 0
    #prices
      # expire_page(controller: 'prices', action: 'index')
      # rm_r "#{Rails.root}/public/prices/page"
      # rm_r "#{Rails.root}/public/prices/cheapest"
      # rm_r "#{Rails.root}/public/prices/groupbuy"


      rm_r "#{Rails.root}/public/costs/page"
    end

  end
end
