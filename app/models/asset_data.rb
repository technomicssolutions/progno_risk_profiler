class AssetData < ActiveRecord::Base
  belongs_to :asset_class
  attr_accessible :date, :data, :asset_data_id, :rolling_1,
    :rolling_2,:rolling_3,:rolling_4,:rolling_5,:rolling_6,:rolling_7,:rolling_8, :rolling_9,:rolling_10,:mean_1,
    :mean_2, :mean_3, :mean_4, :mean_5, :mean_6, :mean_7, :mean_8, :mean_9, :mean_10,
    :stad_deviation_1,:stad_deviation_2,:stad_deviation_3,:stad_deviation_4,:stad_deviation_5,:stad_deviation_6,:stad_deviation_7,:stad_deviation_8,:stad_deviation_9,:stad_deviation_10

  def self.data_between_year(first,last)
    where("date >= '#{first-(5.hour+30.minute)}' AND date <= '#{last-(5.hour+30.minute)}'")
  end

  def self.monthly_data_last(count = 1)
    final_data = self.order("DATE ASC").last
    if final_data.date == final_data.date.end_of_month.to_date then
      final_date = final_data.date.end_of_month.to_date
    else
      final_date = (final_data.date.to_date - 1.month).end_of_month.to_date
    end
    data_set = Array.new
    count.times do
      item = where(date:final_date)
      data_set.push(item.first)

      final_date = (final_date - (1.month)).end_of_month
    end
    data_set
  end

  def self.monthly_data(count = 1,date)
    if date == date.end_of_month.to_date then
      final_date = date
    else
      final_date = (date.to_date - 1.month).end_of_month.to_date
    end
    data_set = Array.new
    count.times do
      item = where(date:final_date)
      data_set.push(item.first)

      final_date = (final_date - (1.month)).end_of_month
    end
    data_set
  end

end

