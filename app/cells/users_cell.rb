class UsersCell < Cell::Rails
  include Devise::Controllers::Helpers
  helper_method :user_signed_in?,:current_user,:get_city_name
  append_view_path "app/views"

  #cache :login do |cell, options|
    #options[:user] ? options[:user].username : nil
  #end

  cache :where do |cell, options|
    options[:city].name
  end

  def login(args)
    @user    = args[:user]
    render
  end

  def where(args)
    #@user    = args[:user]
    @city    = args[:city]
    if @city.blank?
      @city = City.first
      get_city_name(@city)
    end
    render
  end

end
