class PortfolioGroup < ActiveRecord::Base
  belongs_to :rolling_time_period , :dependent => :destroy
  has_many :portfolio_group_assets
  has_many :efficient_frontier
  accepts_nested_attributes_for :portfolio_group_assets

  attr_accessible :name, :rolling_time_period_id, :time_horizon,
    :portfolio_group_assets_attributes,:weight_change, :risk_free, :status

  validates_presence_of :name
  validates_presence_of :time_horizon
  validates_presence_of :weight_change
  validates_presence_of :risk_free
  def asset_mix_generation

    asset = AssetClass.all
    name = Array.new
    asset_id = Array.new
    data = Hash.new
    asset_class_constraints = self.portfolio_group_assets
    asset_class_constraints.each do |item|
      name_process = item.name.split('-').join.downcase
      data["#{name_process}_maximum"] = item.maximum
      data["#{name_process}_minimum"] = item.minimum
      data["#{name_process}_mean"] = self.rolling_time_period.rolling_period_mean.where(asset_class_id:item.asset_class_id).first.mean.to_f
      data["#{name_process}_deviation"] = self.rolling_time_period.rolling_period_mean.where(asset_class_id:item.asset_class_id).first.standard_deviation.to_f
      data["#{name_process}_asset"] = item.asset_class
      name << name_process
      asset_id << item.asset_class_id
    end
    repetetion = name.count
    excutable_string = ""
    name.each do |item|
      excutable_string << "(data['#{item}_minimum']..data['#{item}_maximum']).to_a.each { |#{item}| \n"
    end

    excutable_string << "sum=0\n"

    name.each do |item|
      excutable_string << "sum = sum + #{item}\n"
    end
    excutable_string << "if(sum == 100) then \n"
    excutable_string << "array = Array.new\n"
    name.each do |item|
      excutable_string << "array << #{item}\n"
    end
    excutable_string << "process_data(array,name,data,asset_id)\n"
    excutable_string << "end"
    name.each {
      excutable_string << "}\n"
    }
    eval(excutable_string)
  end
  def process_data(array_d,name,data,asset_id)
    array = array_d.map{ |i| (i * self.weight_change*0.01)}.reverse
    weight_mean = array
    portfolio_return = 0
    name.each do |item|
      portfolio_return = portfolio_return + (weight_mean.pop.to_f*data["#{item}_mean"])
    end
    portfolio_risk = 0
    weight_risk =array_d.map{ |i| (i * self.weight_change*0.01)}.reverse
    name.each do |item|
      w = weight_risk.pop
      portfolio_risk = portfolio_risk + ((w**2)*(data["#{item}_deviation"]**2))
    end
    weight_risk = array_d.map{ |i| (i * self.weight_change*0.01)}
    name.each do
      deviation = data["#{name[0]}_deviation"]
      deviation_1 = data["#{name[1]}_deviation"]
      weight = weight_risk[0]
      weight_1 = weight_risk[1]
      corelation = RollingPeriodCorrelation.where(asset_class_item_one_id:matrix_order(name[0]),asset_class_item_two_id:matrix_order(name[1]),rolling_period_id:self.rolling_time_period_id).first.corelations.to_f
      portfolio_risk = portfolio_risk + (2*weight*weight_1*deviation*deviation_1*corelation)
      name.rotate!
      weight_risk.rotate!
      asset_id.rotate!
    end
    portfolio_risk = portfolio_risk ** (0.5)

    sharpe_ratio = (portfolio_return-self.risk_free)/portfolio_risk
    @ef = self.efficient_frontier.build(composition:array_d.join(':'),:return=>portfolio_return.round(4),risk:portfolio_risk.round(4),sharpe_ratio:sharpe_ratio)
    @ef.save
  end

  def matrix_order(name)
    array = AssetClass.all.map{ |element| element.main_asset_class.split('-').join.downcase}.sort
    array.rindex(name)
  end

  def sorted_list_data
    data = self.efficient_frontier.map{|i| [i.risk.to_f,i.return.to_f]}.sort
    left = data[0][0]
    right = data[0][1]
    big_return = data[0][1]
    dataset = Array.new
    (0..data.length-1).each do |i|
      k = data[i]
      if left == k[0]
        if right > k[1]
          right = k[1]
        end
      else
        if right >= big_return
          dataset << [left,right]
          big_return = right
        end
          left = k[0]
          right = k[1]
      end
    end
    if right >= big_return
      dataset << [left,right]
    end
    dataset
  end

  def sorted_list
    dataset = sorted_list_data
    dataset_object = Array.new
    dataset.each do |item|
      dataset_object << self.efficient_frontier.where("risk = #{item[0]} or return=#{item[1]}").first
    end
    dataset_object.sort! { |a,b| a.risk <=> b.risk }
  end

  def self.best_in_time_horizon(score)
    best_in_time_horizon = {}
    utilities_hash = {}
    risk_penalties = []
    1..10.times do |time_horizon|
      portfolios = self.select([:id]).where(time_horizon:time_horizon,status:true)
      unless portfolios.blank?
        portfolios.each do |portfolio|
          portfolio.efficient_frontier.each do |frontier|
            risk_square = frontier.risk.to_f**2
            risk_penalty = risk_square/score.to_f
    utility = frontier.return.to_f - risk_penalty
    utilities_hash[frontier.id] = utility
    risk_penalties << risk_penalty
  end
end
best_in_time_horizon[time_horizon] = utilities_hash.max
end
end
return best_in_time_horizon
end

def self.plot_graph(best_in_time_horizon, download_type)
    asset_classes = AssetClass.all
    efficient_frontier_array = []
    portfolio_datas = []
    pie_chart = []
    bar_graph = []
    pie=[]
    portfolio_datas=[]
    bar_label=[]
    positive=[]
    negative=[]
    best_in_time_horizon.each do |x|
      efficient_frontier_id = x[1][0]
      efficient_frontier = EfficientFrontier.find efficient_frontier_id
      data = Array.new
      efficient_frontier_composition = efficient_frontier.composition.split(':')
      asset_classes.each_with_index do |value,index|
        data << [value.main_asset_class,efficient_frontier_composition[index].to_i]
      end
      positive_risk = Array.new
      negative_risk = Array.new
      label = Array.new
      options = Hash.new
      0..x[0].times do |year|
        options[year+1] = year+1
      end
      options.each do |value|
        label << "Year #{value[1]}"
        val = 0
        asset_classes.each_with_index do |asset_class,index|
          val += (eval("asset_class.mean_#{value[1]}.to_f*(0.01)*efficient_frontier_composition[index].to_i") + eval("asset_class.stad_deviation_#{value[1]}.to_f*(0.01)*efficient_frontier_composition[index].to_i"))
        end
        positive_risk << val.round(3)
        val = 0
        asset_classes.each_with_index do |asset_class,index|
          val += (eval("asset_class.mean_#{value[1]}.to_f*(0.01)*efficient_frontier_composition[index].to_i") - eval("asset_class.stad_deviation_#{value[1]}.to_f*(0.01)*efficient_frontier_composition[index].to_i"))
        end
        negative_risk << val.abs.round(3)
      end
      if download_type=="excel"
        pie << data
        bar_label << label
        positive << positive_risk
        negative << negative_risk
        portfolio_datas << efficient_frontier
      end
      if download_type!="excel"
        h = LazyHighCharts::HighChart.new('graph', style: '') do |f|
           f.options[:chart][:defaultSeriesType] = "pie"
if download_type=="pdf"
           f.options[:plotOptions][:pie]={:dataLabels=>{:enabled=>true, :style=>{:fontWeight=>'bold', :fontSize=>'20px'},:formatter=>%|function() { return this.point.name + ':' + Math.round(this.percentage);}|.js_code,:distance=> 20, :rotation=> 320},:animation=>true, :shadow=> false}
end
           f.series(:data=>data)
        end
        c = LazyHighCharts::HighChart.new('graph', style: '') do |f|
           f.options[:chart][:defaultSeriesType] = "column"
           f.options[:colors] = '#50B432'
if download_type=="pdf"
           f.options[:plotOptions][:column] = {:stacking => "normal",:borderWidth=>0, :animation => true, :shadow=>false, :enableMouseTracking => true,:dataLabels=> {:enabled=>true,:style=> {:fontWeight=>'bold',:fontSize=>'20px'},:color=>'black'}}
else
 f.options[:plotOptions][:column] = {:stacking => "normal",:borderWidth=>0, :animation => true}
end
           f.options[:xAxis][:categories] = label
           f.options[:xAxis][:gridLineWidth] = 0
           f.options[:yAxis][:gridLineWidth] = 0
           f.options[:yAxis][:labels] = {:enabled => false}
           f.series({:color=>"rgb(0,0,255)",:name=>"Returns(Positive) ",
                     :data => positive_risk,:stack=>"a",
                     :showInLegend => false})
           f.series({:color=>"rgb(255,0,0)",:name=>"Returns(negative)",
                     :data => negative_risk.reverse,:stack=>"a",
                     :showInLegend => false})
        end
        pie_chart << h
        bar_graph << c
        portfolio_datas << efficient_frontier
      end
    end
    if download_type=="excel"
      return pie, portfolio_datas, bar_label, positive, negative
    else
      return pie_chart,bar_graph,portfolio_datas
    end
  end

  def self.total_rows_needed(pie,details,bar)
    if pie>=details && pie>=bar
      return pie
    else
      details>=pie && details>=bar ? details : bar
    end
  end

  def self.draw_pie_graph(sheet,pie,points)
    row_start=points[0]
    row_index=points[1]
    label_start=points[2]
    pie.each_with_index do |label,index|
      sheet.rows[row_index+1].cells[0].value = pie[index].first
      sheet.rows[row_index+1].cells[1].type=:float
      sheet.rows[row_index+1].cells[1].value = pie[index].last
      row_index=row_index+1
    end
    sheet.add_chart(Axlsx::Pie3DChart, :start_at => [2,row_start],
                                       :end_at => [7,row_start+17],
                                       :title=>"Asset allocation") do |chart|
      chart.add_series :data => sheet["B#{label_start+2}:B#{row_index+1}"],
                       :labels => sheet["A#{label_start+2}:A#{row_index+1}"],
                       :colors =>["05E9FF", "0EBFE9", "068481", "080808"]
    end
  end

  def self.init_bar_chart(label_start, bar_labels_count,row_start)
      hash={
          :start_at => [14,label_start+1],
          :barDir => :col,
          :end_at => [15+bar_labels_count,row_start+17],
          :title=>"Risk profile",
          :grouping => :stacked,
          :show_legend => false,
          :shape => :box
      }
  end

  def self.draw_portfolio_details(sheet,details,row_index)
    sheet.rows[row_index+1].cells[8].value="Portfolio risk"
    sheet.rows[row_index+1].cells[9].value=details[:risk]
    row_index=row_index+2
    sheet.rows[row_index].cells[8].value="Returns"
    sheet.rows[row_index].cells[9].value=details[:return]
    row_index=row_index+1
    sheet.rows[row_index].cells[8].value="Sharpe ratio"
    sheet.rows[row_index].cells[9].value=details[:sharpe_ratio]
  end

  def self.fill_bar_labels(row_index,labels,sheet)
    sheet.rows[row_index].cells[10].value = labels[0]
    sheet.rows[row_index].cells[11].type = :float
    sheet.rows[row_index].cells[11].value = labels[1]
    sheet.rows[row_index].cells[12].type = :float
    sheet.rows[row_index].cells[12].value = labels[2]
  end
  def self.draw_bar_graph(sheet,data,points)
    row_start=points[0]
    row_index=points[1]
    label_start=points[2]
    bar_labels=data[0]
    positive_data=data[1]
    negative_data=data[2]
    bar_labels.each_with_index do |bar_label,index|
      row_index=row_index+1
      labels=[bar_labels[index],positive_data[index],negative_data[index]]
      fill_bar_labels(row_index,labels,sheet)
    end
    sheet.add_chart(Axlsx::Bar3DChart, init_bar_chart(label_start,
    bar_labels.count,row_start)) do |chart|
      chart.add_series :data => sheet["M#{label_start+2}:M#{row_index+1}"],
                       :labels=> sheet["K#{label_start+2}:K#{row_index+1}"],
                       :colors => ['FFFF00']*negative_data.count
      chart.add_series :data => sheet["L#{label_start+2}:L#{row_index+1}"],
                       :labels=> sheet["K#{label_start+2}:K#{row_index+1}"],
                       :colors => ['92D050']*positive_data.count
      chart.catAxis.label_rotation=-45
      chart.catAxis.tick_lbl_pos  = :low
    end
  end

  def self.set_fields(sheet,total_rows)
    total_rows.times do
      sheet.add_row [nil]*15
    end
    if total_rows<17;
      (18-total_rows).times do
        sheet.add_row [nil]*15
      end
    end
  end
  def self.generate_excel(graph_datas)
    bar_labels = graph_datas[2]
    pie = graph_datas.first
    positive_data = graph_datas[3]
    negative_data = graph_datas[4]
    portfolio_details = graph_datas[1]
    heading=["Asset", "Percentage"]+[nil]*8+["Year", "Positive", "Negative"]
    package = Axlsx::Package.new
    work_book = package.workbook
    row_index = label_start = row_start = 3
    sheet = work_book.add_worksheet(:name => "asset allocation")
    bold = work_book.styles.add_style :b=>true,
                                      :alignment => { :horizontal => :center }
    3.times { sheet.add_row [nil]*15 }
    pie.count.times do |iteration|
      sheet.add_row heading, :style => [bold]*15 unless iteration+1 >= pie.count
      total_rows = total_rows_needed(pie[iteration].count,
      portfolio_details.count, positive_data[iteration].count)
      set_fields(sheet,total_rows)
      points = [row_start,row_index,label_start]
      draw_pie_graph(sheet,pie[iteration],points)
      draw_portfolio_details(sheet,portfolio_details[iteration],row_index)
      data = [bar_labels[iteration],positive_data[iteration],
      negative_data[iteration].reverse]
      draw_bar_graph(sheet,data,points)
      sheet.add_row heading, :style => [bold]*15 unless iteration+1 > pie.count
      if total_rows<17
        (18-total_rows).times { sheet.add_row [nil]*15 }
        row_start = row_index = label_start = 22
      else
        row_start = label_start = row_start+total_rows+5
        row_index = row_start-1
      end
    end
    return package
  end

end
