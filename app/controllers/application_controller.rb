class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_cache_id,:log_user_agent
  helper_method :city_info_of_ip,:get_city_name,:current_shop

  #def sort_direction  
    #%w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"  
  #end  

  #def sort_column  
    #Good.column_names.include?(params[:sort]) ? params[:sort] : "name"  
  #end          

  def find_able
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return @able = $1.classify.constantize.find(value)  
      end  
    end  
    nil  
  end

  def get_city_name geo
    if geo
      cookies[:lat] = geo.lat
      cookies[:lon] = geo.lon
      cookies[:city] = geo.name
    end
  end

  def city_info_of_ip
    return @ip_infos if @ip_infos and cookies[:ip] == request.ip
    if cookies[:city].nil? or cookies[:ip] != request.ip
      cookies[:ip] = request.ip
      ip = request.ip
      @ip = Ip.where(ip: ip).first_or_create
      get_city_name @ip.city.nil? ? City.first : @ip.city
    end
    ip_infos
  end

  def current_shop
    @current_shop ||= current_user.shops.first
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def admin?
    current_user.id == 1 ? true : not_found
  end


  private
  def get_cache_id
    @cache_id = Time.now.strftime "%Y%m_%d"
  end

  def ip_infos
    @ip_infos = {
      city: cookies[:city],
      lat: cookies[:lat],
      lon: cookies[:lon]
    }
  end

  def log_user_agent
    logger.info "HTTP_USER_AGENT #{request.env["HTTP_USER_AGENT"]}"
  end



end
