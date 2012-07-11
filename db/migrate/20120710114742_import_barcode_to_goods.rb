class ImportBarcodeToGoods < ActiveRecord::Migration
  def up
    source = File.new("./db/tiaoma.sql", "r") 
    while (line = source.gets) 
      execute line 
    end 
    source.close 
  end

  def down
  end
end
