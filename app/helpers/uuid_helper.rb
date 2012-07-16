module UuidHelper
  def before_create()
    self.guid ||= Guid.new.hexdigest.upcase
  end
end
