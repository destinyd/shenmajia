class Ptoc < Thor
  desc :migrate_from_paperclip_to_carrierwave, 'Migrate attachments from paperclip to carrierwave'
  def migrate_from_paperclip_to_carrierwave
    require File.expand_path 'config/environment'

    FileUtils.mkdir_p Rails.root.join('public', 'uploads')

    uploads = Upload.where('image_file_name IS NOT NULL')#.each do |upload|
    dir = Rails.root.join('public', 'images', 'items')
    Dir.foreach(dir).each do |filename|
      uploads.each do |upload|
        if filename =~ Regexp.new("original_#{upload.id}_")
          upload.image = File.open(dir.join(filename))
          upload.save!
          break
        end
      end
    end
  end
end
