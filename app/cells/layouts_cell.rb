class LayoutsCell < Cell::Rails
  cache :footer, :expires_in => 1.day

  cache :trader_nav do |cell, options|
    options[:controller_name]
  end

  def footer
    render
  end

  def trader_nav(args)
    @controller_name = args[:controller_name]
    @action_name = args[:action_name]
    render
  end

  def admin_nav(args)
    @controller_name = args[:controller_name]
    @action_name = args[:action_name]
    render
  end

end
