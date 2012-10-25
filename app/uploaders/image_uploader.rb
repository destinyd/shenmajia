# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  #include CarrierWave::Compatibility::Paperclip

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
    #"image/items"
  #end
  def store_dir
    "p"
  end


  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  def default_url
      #asset_path("fallback/" + ["nopic",version_name].compact.join('_') + ".gif")
    "/images/" + ["nopic",version_name].compact.join('_') + ".gif"
  end


  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end
  #process :resize_to_limit => [1280, 6000]

  version :large do
    process :resize_to_limit => [640, 3000]
  end

  version :pin do
    process :resize_to_limit => [180, nil]
  end


  version :medium do
    process :resize_and_pad => [180, 180]
  end

  version :list do
    process :resize_and_pad => [120, 120]
  end

  def image
    begin
      @image ||= MiniMagick::Image.open(file.path)
    rescue
      @image ||= {'width'=> 0,'height'=> 0}
    end
    @image
  end

  def width
    @width ||= image['width']
  end

  def height
    @height ||= image['height']
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{(model.created_at || DateTime.now).strftime '%Y%m'}/#{secure_token}.#{file.extension}" if original_filename.present?
    ##"#{model.id}_#{model.updated_at}.#{extension}"# if original_filename
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
