require 'open-uri' 
class Jiepang
  @@count = 15
  @@url = 'http://api.jiepang.com/v1/'
  CONFIG = {}
  def initialize(args = {})

  end

  def key; config['key'];  end
  def secret; config['secret']; end

  def locations_photos guid,page =1
    args = {:guid => guid,:page => page.to_s}
    json = get_json('locations/photos',args)
  end

  def locations_show guid
    args = {:guid => guid}
    json = get_json('locations/show',args)
  end

  def search args
    json = get_json_of_search args
    if json and json["items"].length > 0
      guids = json["items"].map{|j| j["guid"]}

      #import json
      exist_places_guid = Place.where(:guid => guids).select(:guid).map(&:guid)
      json['items'].delete_if{|i|  exist_places_guid.include?(i['guid'])}
      Place.create json["items"] unless json['items'].blank?

      json["places"] = Place.where(:guid =>guids)
      #puts guids
      #puts json
      return json
    end
    {}
  end


  def get_json_of_search args= {}
    p_args = args
    #p_args[:q] = args[:q] ? URI.escape(args[:q]) : nil
    #p_args[:city] = args[:city] ? URI.escape(args[:city]) : nil
    #url = "#{@@url}locations/search?lat=#{args[:lat]}&lon=#{args[:lon]}&count=#{args[:count] || @@count}&q=#{q}&city=#{city}&page=#{args[:page]}&source=#{key}" #&category_id=#{args[:category_id]}&apiver=#{args[:category_id].blank? ? 1 : 2}  v2
    #puts url
    #begin
    json = get_json 'locations/search',p_args
    #str_json = open(url).read
    #json = JSON.parse(str_json)
    #rescue Exception => e
    #puts e.message  
    #puts e.backtrace.inspect  
    #{}
    #end
  end

  def get_json action,args
    args.merge! :source => key,:count => @@count.to_s
    str_p = ''
    #puts args
    args.each do |k,v|
      str_p += "&#{k}=#{URI.escape(v)}" unless v.blank?
    end
    url = "#{@@url}#{action}?#{str_p}"
    #puts url
    begin
      str_json = open(url).read
      json = JSON.parse(str_json)
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect  
      {}
    end

  end

  protected
  def config
    CONFIG['jiepang'] ||= lambda do
      require 'yaml'
      filename = "#{Rails.root}/config/jiepang.yml"
      file     = File.open(filename)
      yaml     = YAML.load(file)
      return yaml[Rails.env]
    end.call
  end
end
