class AssetClass < ActiveRecord::Base
  @data_end_of_each_month

  has_many :asset_datas, :dependent => :destroy
  has_many :rolling_year_datas, :dependent => :destroy
  attr_accessible :benchmark, :main_asset_class, :sub_asset_class, :data_points,:no_of_days,:no_of_months,:no_of_years,
    :mean_1, :mean_2, :mean_3, :mean_4, :mean_5, :mean_6, :mean_7, :mean_8, :mean_9, :mean_10,
    :stad_deviation_1,:stad_deviation_2,:stad_deviation_3,:stad_deviation_4,:stad_deviation_5,:stad_deviation_6,:stad_deviation_7,:stad_deviation_8,:stad_deviation_9,:stad_deviation_10
  has_attached_file :data_points
  attr_accessor :data_end_of_each_month

  def process_data_points
    require 'csv'
    upload_time = Time.now
    day = 0
    year =  Hash.new
    month = Hash.new
    puts "url"
    puts self.data_points
    begin
      data = CSV.read(Rails.root.join("public#{self.data_points.url.split('?')[0]}"))
    rescue Exception => e
      return ["Please upload a datafile"]
    end    
    date = get_date data[0][0]
    old_data_point = data[0][1]
    if old_data_point.blank? then
      ["Uploaded data is not valid"]
    else
      @data_end_of_each_month = Hash.new
      save_data_point(date[:time_object],old_data_point,upload_time)
      first = date[:time_object]
      year["#{date[:date_object].year}"] = true
      month["#{date[:date_object].month}X#{date[:date_object].year}"] = true
      data.delete_at(0)
      data.uniq!
      old = date[:date_object]
      today = 0
      data.each do |line|
        if line.length > 0 && not(line[0].blank?) then
          today = get_date line[0]
          old = old.next
          if old != today[:date_object] then
            while old != today[:date_object]
              save_data_point old.to_time,old_data_point,upload_time
              old = old.next
            end
            save_data_point old.to_time,line[1],upload_time
            old_data_point = line[1]
          else
            save_data_point today[:date_object],line[1],upload_time
            old_data_point = line[1]
          end
          day += 1      
          year["#{today[:date_object].year}"] = true unless year.has_key?("#{today[:date_object].year}")
          month["#{today[:date_object].month}X#{today[:date_object].year}"] = true unless month.has_key?("#{today[:date_object].month}X#{today[:date_object].year}")
        end
      end
      last_data_set = self.asset_datas.order("ID ASC").last
      last = last_data_set.date.to_date
      rolling_daily(first,last)
      [day,month.length, year.length]
    end
  end
  

  def global_mean_and_deviation
    (1..10).each do |i|
      dataset = self.rolling_year_datas.where(rolling_period:i).map{|i| i.data.to_f}.to_scale
      self.update_attribute("mean_#{i}",dataset.mean)
      self.update_attribute("stad_deviation_#{i}",dataset.sd)
    end
  end
  def get_date(line)
    if line =~ /[0-9]+\/[0-9]+\/[0-9]+/
      temp = line.split('/').map{ |i| i.to_i}
      date = [temp[2],temp[0],temp[1]]
    elsif line =~ /[0-9]{8}/
      date = [line[0..3].to_i,line[4..5].to_i,line[6..7].to_i]
    elsif line =~ /[0-9]{1,2}-[a-zA-Z]{3}-[0-9]{1,2}/
      month_numerical = name_of_month_to_digit(line.scan(/[a-zA-Z]{3}/)[0].downcase)
      temp = line.scan(/[0-9]{1,2}/)
      if temp[1][0]=="9"
        temp[1] = "19#{temp[1]}".to_i
      else
        temp[1] = "20#{temp[1]}".to_i
      end
      date = [temp[1],month_numerical,temp[0].to_i]
    end
    {
      date_object: Date.new(date[0],date[1],date[2]),
      time_object: Time.new(date[0],date[1],date[2])
    }
  end

  # to get the last day of month, case have been places in case the
  # the year is a leap year

  def name_of_month_to_digit(month)
    name_of_month = {""=>0, "jan"=>1, "feb"=>2, "mar"=>3, "apr"=>4, "may"=>5, "jun"=>6, "jul"=>7, "aug"=>8, "sep"=>9, "oct"=>10, "nov"=>11, "dec"=>12}
    name_of_month["#{month}"]
  end

  def save_data_point(date,data,upload_time)
    @asset_data = self.asset_datas.build
    @asset_data.date = date
    @asset_data.data = data.split(',').join.to_f
    @asset_data.upload_time = upload_time
    @asset_data.save
    save_rolling_data_for_month(date,data)
  end

  def save_rolling_data_for_month(date,data,flag = false)
    if !@data_end_of_each_month.has_key?("#{date}") then
      if date.to_date == date.end_of_month.to_date || flag
        @data_end_of_each_month["#{date}"] = data.split(',').join.to_f
      end
    end
  end

  def rolling
    length = @data_end_of_each_month.values.count - 1
    asset_data = self.asset_datas.order("ID ASC").last
    last_date = asset_data.date
    (1..10).each do |i|
      item = length
      last_date = asset_data.date
      j = 0
      statistical_samples = []
      while (item-(12*i))>0
        @rolling_year_data = self.rolling_year_datas.build
        @rolling_year_data.date = last_date
        @rolling_year_data.data = (((@data_end_of_each_month.values[item]/@data_end_of_each_month.values[item-(12*i)])**(1.to_f/i.to_f))-1)*100
        statistical_samples << @rolling_year_data.data.to_f
        @rolling_year_data.rolling_period = i
        item = item -1
        j = j + 1
        temp = Time.new((last_date-1.month).year,(last_date-1.month).month,(last_date-1.month).end_of_month.day)
        last_date = temp
      end
      a = statistical_samples.to_scale
      self.update_attribute("mean_#{i}",a.mean)
      self.update_attribute("stad_deviation_#{i}",a.sd)
    end
    @data_end_of_each_month = Hash.new
  end

  def rolling_daily(first,last)
    (1..10).each do |i|
      self.asset_datas.data_between_year(first,last).order("ID DESC").each do |asset_data|
        asset_data_2 = self.asset_datas.where(date:(asset_data.date-(i.year+5.hour+30.minutes)))
        if asset_data_2.count != 0 then
          rolling_value = (((asset_data.data.to_f/asset_data_2.first.data.to_f)**(1.to_f/i.to_f))-1)*100
          @rolling_year_data = self.rolling_year_datas.build
          @rolling_year_data.date = asset_data.date - (5.hour+30.minutes)
          @rolling_year_data.data = rolling_value
          @rolling_year_data.rolling_period = i
          @rolling_year_data.save
        else
          break;
        end
      end
    end
  end
end
