module PosHelper
  def pos
    [lat,lon]
  end

  def pos=(arr)
    self.lat,self.lon = arr
  end
end