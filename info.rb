#Good.batch_size(1000).no_timeout.with_barcode.only(:barcode,:_id).all.each do |good|
  #good.infos.create result: lt.post(good.barcode), provider: 'liantu'
#end
total_pages = Good.page.total_pages
@lt = GetMoreInfo.liantu
THREAD_COUNT = 100
total_pages = 127436
@pages = (1..total_pages).to_a
def get_infos
  while @pages.count > 0
    page = @pages.pop
    get_info(@lt, page)
  end
end
def get_info(lt, page)
  Good.page(page).only(:barcode,:_id).each do |good|
    good.infos.create result: lt.post(good.barcode), provider: 'liantu'
  end
end
threads = []
THREAD_COUNT.times do |index|
  threads << Thread.new { get_infos}
end

@start = Time.now

while true
  p "info count: #{Info.count},last page:#{@pages.last}, remain: #{@pages.count}, cost: #{Time.cc_time(@start)}"
  sleep 5
end
#pages.each do |page|
  #p page
  #Good.page(page).no_timeout.with_barcode.only(:barcode,:_id).all.each do |good|
    #good.infos.create result: lt.post(good.barcode), provider: 'liantu'
  #end
#end
