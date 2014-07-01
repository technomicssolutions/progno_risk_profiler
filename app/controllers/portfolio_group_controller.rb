class PortfolioGroupController < ApplicationController

  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(4)}

  caches_action :index, :portfolio_status

  def index
    @portfolio_group  = PortfolioGroup.new
    @portfolio_groups = PortfolioGroup.all
    data = AssetClass.all.map{ |data| data.id }
    name = AssetClass.all.map{ |data| data.main_asset_class }
    name.count.times do
      @portfolo_groups_asset = @portfolio_group.portfolio_group_assets.build
      @portfolo_groups_asset.asset_class_id  = data.pop
      @portfolo_groups_asset.name  = name.pop
    end
    @name = AssetClass.all.map{ |data| data.main_asset_class }
  end

  def create
    @portfolio_group = PortfolioGroup.new params[:portfolio_group]
    if @portfolio_group.save then
      @portfolio_group.asset_mix_generation
      expire_action :action => :index
      flash[:notice] = "Sucess"
      redirect_to '/admin/investment/portfolio_group'
    else
      flash[:error] = @portfolio_group.errors.full_messages.to_sentence
      redirect_to '/admin/investment/portfolio_group'
    end
  end

  def efficient_frontier
    @portfolio_groups = PortfolioGroup.all
    if params[:id].present? then
      @portfolio_group = PortfolioGroup.find params[:id]
    else
      @portfolio_group = @portfolio_groups.first
    end
    @dataset = @portfolio_group.sorted_list_data
    @dataset_object = @portfolio_group.sorted_list

    @name = AssetClass.all.map{|i| i.main_asset_class}
    @h = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:chart][:defaultSeriesType] = "line"
      f.series(:name=> '', :data=>@dataset, :showInLegend => false)
#f.series(series.showInLegend = false;)
      f.options[:yAxis][:title] = {enabled:true,text:"Return"}
      f.options[:xAxis][:title] = {enabled:true,text:"Risk"}
      f.options[:tooltip][:formatter] = %|function() { return '<b>Risk:</b>' +  this.x + '<br>'+ '<b>Returns:</b>' + this.y;}|.js_code
      f.options[:chart] = {:events => { :click => %|function(event) { alert('data'+event.xAxis[0].value); }|.js_code } }
    end
  end

  def periodic_risk

    @asset_classes = AssetClass.all
    if params[:g_id].present? then
      @portfolio_group = PortfolioGroup.find(params[:g_id])
    else
      render 'periodic_risk_select' and return
    end

    if params[:id].present? then
      @efficient_frontier = @portfolio_group.efficient_frontier.find(params[:id])
    else
      @efficient_frontier = @portfolio_group.sorted_list.first
    end
    options = Hash.new
    if params[:first].present? then
      options[:first] = params[:first].to_i
      options[:second] = params[:second].to_i
      options[:third] = params[:third].to_i
      options[:fourth] = params[:fourth].to_i
    else
      options[:first] = 1
      options[:second] = 3
      options[:third] = 5
      options[:fourth] = 10
    end
    @data = Array.new
    @efficient_frontier_composition = @efficient_frontier.composition.split(':')
    @portfolio_group.portfolio_group_assets.each_with_index do |data,index|
      @data << [data.name,@efficient_frontier_composition[index].to_i]
    end
    @positive_risk = Array.new
    @negative_risk = Array.new
    @label = Array.new
    options.each do |value|
      @label << "Year #{value[1]}"
      val = 0
      @asset_classes.each_with_index do |asset_class,index|
        val += (eval("asset_class.mean_#{value[1]}.to_f*(0.01)*@efficient_frontier_composition[index].to_i") + eval("asset_class.stad_deviation_#{value[1]}.to_f*(0.01)*@efficient_frontier_composition[index].to_i"))
      end
      @positive_risk << val
      val = 0
      @asset_classes.each_with_index do |asset_class,index|
        val += (eval("asset_class.mean_#{value[1]}.to_f*(0.01)*@efficient_frontier_composition[index].to_i") - eval("asset_class.stad_deviation_#{value[1]}.to_f*(0.01)*@efficient_frontier_composition[index].to_i"))
      end
      @negative_risk << val.abs
    end
    @h = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = "pie"
      f.series(:data=>@data)
    end
    @c = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:plotOptions][:column] = {:stacking => "normal",:borderWidth=>0}
      f.options[:xAxis][:categories] = @label
       f.options[:yAxis][:labels] = "returns"
      f.series({:color=>"rgb(0,0,255)",:name=>"Returns ",:data => @positive_risk,:stack=>"a"})
      f.series({:color=>"rgb(255,0,0)",:name=>"Returns",:data => @negative_risk.reverse,:stack=>"a"})
    end
  end

  def destroy
    @pg = PortfolioGroup.find params[:id]
    if @pg.destroy then
      flash[:notice] = "Deleted"
      expire_action :action => :index
    else
      flash[:error] = "Not Deleted"
    end
    redirect_to '/admin/investment/portfolio_group' and return
  end

  def portfolio_status
    @portfolio_groups = PortfolioGroup.select([:id,:status,:name,:time_horizon])
  end

  def change_portfolio_status
    portfolio = PortfolioGroup.find params[:id]
    status = params[:status]
    if portfolio.update_attributes(status:status)
      expire_action :action => :portfolio_status
      flash[:notice] = "Status Changed"
    else
      flash[:error] = portfolio.errors.full_messages.to_sentence
    end
    redirect_to '/admin/investment/portfolio_group/portfolios' and return
  end

end
