class RollingYearData < ActiveRecord::Base
  belongs_to :asset_class
  attr_accessible :date,:asset_classes_id,:data,:rolling_period

  def self.data_between_year(first,last,rolling_period)
    where("date >= '#{first}' AND date <= '#{last}' AND rolling_period == '#{rolling_period}'")
  end

  def self.monthly_data_last(count = 1,rolling_period)
    final_data = self.order("DATE ASC").last
    if final_data.date == final_data.date.end_of_month.to_date then
      final_date = final_data.date.end_of_month.to_date
    else
      final_date = (final_data.date.to_date - 1.month).end_of_month.to_date
    end
    data_set = Array.new
    count.times do
      item = where(date:final_date,rolling_period:rolling_period)
      data_set.push(item.first)
      final_date = (final_date - (1.month)).end_of_month
    end
    data_set
  end

  def self.monthly_data(count = 1,date,rolling_period)
    if date == date.end_of_month.to_date then
      final_date = date
    else
      final_date = (date.to_date - 1.month).end_of_month.to_date
    end
    data_set = Array.new
    count.times do
      item = where(date:final_date,rolling_period:rolling_period)
      data_set.push(item.first)
      final_date = (final_date - (1.month)).end_of_month
    end
    data_set
  end

end
