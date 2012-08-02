module SweepersHelper
  def rm(dir)
    File.delete dir if File.exist?(dir)
  end

  def rm_r(dir)
    FileUtils.rm_r dir if File.exist?(dir)
  end
end

