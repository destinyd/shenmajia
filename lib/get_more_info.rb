class GetMoreInfo
  URLS={liantu: 'http://www.liantu.com/tiaoma/query.php'}
  #PARAMS={liantu: 'ean'}

  attr_accessor :provider, :params, :result, :url
  def initialize(args)
    @provider = args[:provider]
    @params = args[:params]
    @url = URLS[@provider]
  end

  def post barcode
    @result = RestClient.post @url, 
      {
        ean: barcode
      }
  end

  def json str_result
    begin
      JSON.parse str_result unless str_result.blank?
    rescue
    end
  end

  def get_json barcode
    json post barcode
  end

  def self.liantu
    GetMoreInfo.new provider: :liantu
  end

  def self.urls
    URLS
  end

  def self.get_liantu thread_count = 100
    total_pages = Good.page.total_pages
    @lt = GetMoreInfo.liantu
    @pages = (1..total_pages).to_a
    @threads = []

    thread_count.times do |index|
      @threads << Thread.new { get_liantu_infos}
    end

    @start = Time.now
  end

  def self.p_process(timeout = 60)
    while true
      p "info count: #{Info.count},last page:#{@pages.last}, remain: #{@pages.count}, cost: #{Time.cc_time(@start)}"
      sleep timeout
    end
  end

  #private
  def self.get_liantu_infos
    while @pages.count > 0
      page = @pages.pop
      get_liantu_info(@lt, page)
    end
  end

  def self.get_liantu_info(lt, page)
    Good.page(page).only(:barcode,:_id).each do |good|
      good.infos.create result: lt.post(good.barcode), provider: 'liantu'
    end
  end

  def self.threads
    @threads
  end
end
