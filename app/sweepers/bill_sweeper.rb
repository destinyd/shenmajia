class BillSweeper < ActionController::Caching::Sweeper
  observe Bill
  include SweepersHelper

  def after_create(bill)
    expire_cache_for(bill)
  end
 
  # If our sweeper detects that a bill was updated call this
  def after_update(bill)
    expire_cache_for(bill)
    #expire_cache_for_single(bill)
  end
  private
  def expire_cache_for_other(obj)
    p = "/#{obj.class.name.downcase.pluralize}/#{obj.id}"
    expire_page(p)
    expire_cache_for_obj_bills(p)
  end

  def expire_cache_for_obj_bills(dir)
    if !dir.blank? and dir.length > 2
      p="#{Rails.root}/public#{dir}"
      FileUtils.rm_r p if File.exist? p
    end
  end
  
  def expire_cache_for(bill)
    expire_page(controller: 'bills', action: 'index')#  if bill.id % 10 == 0

    #expire_cache_for_other(bill.locatable) unless bill.locatable.blank?
    # expire_cache_for_other(bill.good) unless bill.good.blank?

    #good
    unless bill.goods.blank?
      bill.goods.each do |good|
        rm "#{Rails.root}/public/goods/#{good.id}.html"
        rm_r "#{Rails.root}/public/goods/#{good.id}"
      end
    end

    #cities
    if bill.locatable and bill.locatable.city_id?
      rm "#{Rails.root}/public/cities/#{bill.locatable.city.name}.html" 
      rm_r "#{Rails.root}/public/cities/#{bill.locatable.city.name}"
    end

    if bill.id % 10 == 0
    #prices
       expire_page(controller: 'prices', action: 'index')
       rm_r "#{Rails.root}/public/prices/page"
       rm_r "#{Rails.root}/public/prices/cheapest"
      # rm_r "#{Rails.root}/public/prices/groupbuy"


      rm_r "#{Rails.root}/public/bills/page"
    end

  end
end

