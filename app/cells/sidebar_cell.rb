class SidebarCell < Cell::Rails
  helper_method :section
  append_view_path "app/views"

  cache :login do |cell, options|
    options[:prices].md5
  end

  def tuijian(args)
    @city   = City.find_by_name args[:city]
    @prices = @city.prices.tuijian
    @prices = Price.tuijian if @price.blank?
    render
  end

  def near(args)
    @price = args[:price]
    @prices = @price.near_prices.where(good_id: @price.good_id).cheapest.includes(:good).limit(10)
    render
  end

  def cheap(args)
    @price = args[:price]
    @prices = @price.good.prices.cheapest.where("id != ?",@price.id).includes(:good).limit(10)
    render
  end

end
