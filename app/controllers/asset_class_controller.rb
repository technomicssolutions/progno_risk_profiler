class AssetClassController < ApplicationController

  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(4)}

  caches_action :index, :rolling_time_period, :view_matrics

  def index
    @asset_classes = AssetClass.all rescue AssetClass.new
  end

  def new
    @asset_class = AssetClass.new
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @asset_class = AssetClass.find params[:id]
    if @asset_class.destroy then
      expire_action :action => :index
      flash[:notice] = "Deleted"
    else
      flash[:notice] = "Not Deleted"
    end
    redirect_to '/admin/investment/asset_class' and return
  end

  def edit
    @asset_class = AssetClass.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def update
    @asset_class = AssetClass.find params[:asset_class][:id]
    if @asset_class.update_attributes params[:asset_class] then
      expire_action :action => :index
      flash[:notice] = "Asset Class Sucessfully Edited"
      redirect_to '/admin/investment/asset_class'
    else
      flash[:error] = "#{@asset_class.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def create
    @assetClass = AssetClass.new params[:asset_class]
    if @assetClass.save then
      expire_action :action => :index
      flash[:notice] = "Saved Sucessfully"
      redirect_to '/admin/investment/asset_class'
    else
      flash[:error] = "@asset_class.errors.full_messages.to_sentence"
      render 'new'
    end
  end

  def data_point_upload
    @asset_class = AssetClass.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def file_update
    @asset_class = AssetClass.find params[:asset_class][:id]
    params[:asset_class].delete("id")
    if params[:asset_class][:data_points].original_filename.split('.')[1] != "csv" then
      flash[:error] = "Kindly upload a CSV file"
      redirect_to '/admin/investment/asset_class'
    elsif @asset_class.update_attributes params[:asset_class] then
      flash[:notice] = "Saved Sucessfully"
      count = @asset_class.process_data_points
      @asset_class.update_attributes(no_of_days: count[0] , no_of_months:count[1],no_of_years:count[2])
      expire_action :action => :index
      redirect_to '/admin/investment/asset_class'
    else
      flash[:error] = "@asset_class.errors.full_messages.to_sentence"
    end
    redirect_to '/admin/investment/asset_class'

  end

  def flush_data
    @asset_class = AssetClass.find params[:id]
    if @asset_class.asset_datas.delete_all then
      @asset_class.rolling_year_datas.delete_all
      @asset_class.update_attributes(no_of_days: 0 , no_of_months:0,no_of_years:0)
      expire_action :action => :index
      flash[:notice] = "All the data points from this table has been flushed"
    else
      flash[:error] = "@asset_class.errors.full_messages.to_sentence"
    end
    redirect_to '/admin/investment/asset_class'
  end

  def correlation_matrix
    name_asset = [" "]
    name_asset << AssetClass.each.map{|i| i.main_asset_class}.sort
    size = name_asset.length
  end

  def rolling_time_period
    @asset_class = AssetClass.all
    @rolling_time_period = RollingTimePeriod.all
  end

  def rolling_time_period_new
    @rolling_time_period = RollingTimePeriod.new
    @assets_classes = AssetClass.all
    respond_to do |format|
      format.js
    end
  end

  def rolling_time_period_create
    @rolling_time_period = RollingTimePeriod.new params[:rolling_time_period]
    if @rolling_time_period.save
      expire_action :action => [:rolling_time_period, :view_matrics]
      @rolling_time_period.calculate_rolling_stats
      flash[:notice] = "New Time Period Saved"
    else
      flash[:error] = @rolling_time_period.errors.full_messages.to_sentence
    end
    redirect_to admin_investment_asset_class_set_time_periods_path
  end

  def rolling_time_period_edit
    @rolling_time_period = RollingTimePeriod.find params[:id]
    @assets_classes = AssetClass.all
    respond_to do |format|
      format.js
    end
  end

  def rolling_time_period_update
    @rolling_time_period = RollingTimePeriod.find params[:rolling_time_period][:id]
    if @rolling_time_period.update_attributes params[:rolling_time_period]
      expire_action :action => [:rolling_time_period, :view_matrics]
      flash[:notice] = "Updated"
    else
      flash[:error] = @rolling_time_period.errors.full_messages.to_sentence
    end
    redirect_to admin_investment_asset_class_set_time_periods_path
  end

  def rolling_time_period_delete
    @rolling_time_period = RollingTimePeriod.find params[:id]
    if @rolling_time_period.destroy
      expire_action :action => :rolling_time_period
      flash[:notice] = "Deleted"
    else
      flash[:error] = @rolling_time_period.errors.full_messages.to_sentence
    end
    redirect_to admin_investment_asset_class_set_time_periods_path
  end

  def view_matrics
    @rolling_time_period = RollingTimePeriod.all
  end

  def update_view_matrics
    @rolling_time_period =  RollingTimePeriod.find(params[:id]) if params[:id]
    @rolling_time_period.calculate_rolling_stats
    flash[:notice] = "updated"
    redirect_to admin_investment_asset_class_set_time_periods_path
  end

  def view_matrics_stats
    rolling_time_period = RollingTimePeriod.find(params[:id]) if params[:id]
    @rolling_stats = RollingPeriodMean.where(:rolling_time_period_id=>rolling_time_period)
    @rolling_corelation = RollingPeriodCorrelation.where(:rolling_period_id => rolling_time_period.id)
    @asset_class_names=AssetClass.order(:id).collect(&:main_asset_class).sort
    @count = @asset_class_names.count
    respond_to do |format|
      format.js
    end
  end

  def download_stats
    @rolling_time_period = RollingTimePeriod.find(params[:id]) if params[:id]
    time_period = @rolling_time_period.rolling_period_added
    data_units = @rolling_time_period.return_units_no
    asset_data_count = data_units + (12*time_period)
    @temp_period = (12*time_period)
    end_date = @rolling_time_period.end_date
    asset_classes = AssetClass.all
    @data = []
    @asset_raw_datas = []
    asset_classes.each do |name|
      @asset_raw_datas << name.asset_datas.monthly_data(asset_data_count,end_date).reverse()
      @data << name.rolling_year_datas.monthly_data(asset_data_count,end_date,time_period).reverse()
    end
    @raw_data_count = @asset_raw_datas.count
    respond_to do |format|
      format.xls
      format.json
    end
  end

end
