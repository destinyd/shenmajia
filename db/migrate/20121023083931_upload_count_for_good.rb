class UploadCountForGood < ActiveRecord::Migration
  def up
    Upload.where(uploadable_type: 'Good').all.each do |upload|
      Good.update_counters upload.uploadable.id,picture_count:1
      Bill.update_counters upload.uploadable.bill_ids, picture_count:1
    end
  end

  def down
    Bill.update_all({picture_count: 0},'picture_count > 0')
    Good.update_all({picture_count: 0},'picture_count > 0')
  end
end
