# coding: utf-8
module UnitInitHelper
  def before_create()
    self.unit ||= '份'
  end
end
