class RollingTimePeriod < ActiveRecord::Base
  attr_accessible :asset_class_id, :data_unit, :end_date, :return_units_no, :rolling_period_added, :start_date
  has_many :rolling_period_mean
  has_many :rolling_period_correlation

  def asset_allocation
    asset_allocation_id = self.rolling_period_added.to_s
    if self.data_unit == "Month" then
      asset_allocation_id <<  "12"
    elsif self.data_unit == "Day" then
      asset_allocation_id << "365"
    end
    asset_allocation_id <<  self.return_units_no.to_s
  end

  def start_date_cal
    if self.data_unit == "Month" then
      self.end_date - (self.return_units_no+self.rolling_period_added*12).month
    end
  end


  def calculate_rolling_stats
    rolling_period = self.rolling_period_added
    return_units = self.return_units_no
    end_date = Date.new self.end_date.year,self.end_date.month,self.end_date.day
    asset_classes = AssetClass.order(:id)
    dataset = Hash.new
    data_array = Array.new
    asset_class_order = Hash.new
    RollingPeriodMean.delete_all(:rolling_time_period_id => self.id)
    asset_classes.each do |a|
      @rolling_period_datas = []
      asset_class_order["#{a.main_asset_class}"] = a.id
      if self.data_unit == "Month"
        asset_datas = a.rolling_year_datas.monthly_data(return_units,end_date,rolling_period)
      else
        asset_datas = a.rolling_year_datas.where("rolling_period =? AND date < ?",rolling_period,end_date).order("DATE DESC").limit(return_units)
      end
      unless asset_datas.blank?
        asset_datas.each do |datas|
          @rolling_period_datas << datas.data.to_f
        end
        rolling_period_datas_vector = @rolling_period_datas.to_scale
        rolling_period_mean = rolling_period_datas_vector.mean
        rolling_period_sd = rolling_period_datas_vector.sd
        rolling_period_stats = RollingPeriodMean.create(:mean => rolling_period_mean, :standard_deviation => rolling_period_sd, :asset_class_id => a.id, :rolling_time_period_id => self.id)

        #correlations
        if self.data_unit == "Month"
          dataset["#{a.main_asset_class}"] = a.rolling_year_datas.monthly_data(return_units,end_date,rolling_period).map{ |i| i.data.to_f }.to_scale
        else
          dataset["#{a.main_asset_class}"] = a.rolling_year_datas.where("rolling_period =? AND date < ?",rolling_period,end_date).order("DATE DESC").limit(return_units).map { |j| j.data.to_f  }.to_scale
        end
        ds=dataset.to_dataset
        cm=Statsample::Bivariate.correlation_matrix(ds)
        z = 0
        RollingPeriodCorrelation.delete_all(:rolling_period_id => self.id)

        asset_class_order.each do |key_1,value_1|
          j=0
          asset_class_order.each do |key_2,value_2|
            a = RollingPeriodCorrelation.new
            a.rolling_period_id = self.id
            a.asset_class_item_one_id =z
            a.asset_class_item_two_id =j
            a.corelations = cm.rows[z][j]
            j=j+1
            a.save
          end
          z=z+1
        end
      end
    end
  end
end
