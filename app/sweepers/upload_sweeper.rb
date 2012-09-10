class UploadSweeper < ActionController::Caching::Sweeper
  observe Upload
  include SweepersHelper

  def after_create(upload)
    expire_cache_for(upload)
  end
 
  def after_update(upload)
    expire_cache_for(upload)
    expire_cache_for_single(upload)
  end
  private
  def expire_cache_for_single(upload)
    expire_page(controller: 'uploads', action: 'show', id: upload.id)
  end

  def expire_cache_for_other(obj)
    p = "/#{obj.class.name.downcase.pluralize}/#{obj.id}"
    expire_page(p)
    expire_cache_for_obj_uploads(p)
  end

  def expire_cache_for_obj_uploads(dir)
    if !dir.blank? and dir.length > 2
      p="#{Rails.root}/public#{dir}"
      FileUtils.rm_r p if File.exist? p
    end
  end
  
  def expire_cache_for(upload)
    expire_page('/uploads')

    #good
    expire_cache_for_other(upload.uploadable) if upload.uploadable

    rm_r "#{Rails.root}/public/uploads/page"

  end
end
