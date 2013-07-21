class SidebarCell < Cell::Rails
  helper_method :section
  append_view_path "app/views"

  def tuijian(args)
    @city   = City.where(name: args[:city]).first
    @prices = @city.prices.tuijian
    @prices = Price.tuijian if @price.blank?
    render
  end

  def near(args)
    @price = args[:price]
    @prices = @price.near_prices.blank? ? [] : @price.near_prices.where(good_id: @price.good_id).cheapest.includes(:good).limit(10)
    render
  end

  def cheapest(args)
    @good = args[:good]
    @prices = @good ?  @good.prices.cheapest.includes(:good).limit(10) : []
    render
  end

  def recent(args)
    @good = args[:good]
    @prices = @good ? @good.prices.recent.includes(:good).limit(10) : []
    render
  end

  def recent_costs(args)
    @user = args[:user]
    @costs = @user.costs.recent.limit(10)
    render
  end

end
