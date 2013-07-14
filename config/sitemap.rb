# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://shenmajia.com'

SitemapGenerator::Sitemap.create do
  Bill.all.each do |c|
    add bill_path(c), lastmod: (c.updated_at || c.created_at), :priority => 0.9
  end

  Cost.all.each do |c|
    add cost_path(c), lastmod: (c.updated_at || c.created_at), :priority => 0.8
  end

  Price.all.each do |c|
    add price_path(c), lastmod: (c.updated_at || c.created_at), :priority => 0.8
  end

  Good.all.each do |c|
    add good_path(c), lastmod: (c.updated_at || c.created_at), :priority => 0.7
  end

  add bills_path, :changefreq => 'daily', :priority => 0.6
  add prices_path, :changefreq => 'daily', :priority => 0.6
  add costs_path, :changefreq => 'daily', :priority => 0.6
  add uploads_path, :changefreq => 'daily', :priority => 0.5
  add goods_path, :changefreq => 'weekly', :priority => 0.5

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.all.each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
