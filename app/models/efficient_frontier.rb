class EfficientFrontier < ActiveRecord::Base
  belongs_to :portfolio_group
  attr_accessible :composition, :return, :risk, :portfolio_group_id, :sharpe_ratio

  def sorted_list_data
    data = @portfolio_group.efficient_frontier.map{|i| [i.risk.to_f,i.return.to_f]}.sort
    left = data[0][0]
    right = data[0][1]
    big_return = data[0][1]
    @dataset = Array.new
    (0..data.length-1).each do |i|
      k = data[i]
      if left == k[0]
        if right > k[1]
          right = k[1]
        end
      else
        if right >= big_return
          @dataset << [left,right]
          big_return = right
        end
        left = k[0]
        right = k[1]
      end
    end
    if right >= big_return
      @dataset << [left,right]
    end
    @dataset

  end

end
