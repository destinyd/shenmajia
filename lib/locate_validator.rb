# coding: utf-8
class LocateValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.to_f == 0.0 and record.lon.to_f == 0.0
      record.errors[:base] << "未选定坐标"
    end
  end
end
