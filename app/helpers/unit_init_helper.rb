# coding: utf-8
module UnitInitHelper
  def before_validation
    self.unit ||= '份'
  end
end
