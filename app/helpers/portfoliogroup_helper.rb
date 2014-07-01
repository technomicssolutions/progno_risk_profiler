module PortfoliogroupHelper
  def asset_class_name(value)
    AssetClass.find(value).main_asset_class
  end

  def delete_portfolio_group(id)
    link_to '&nbsp;'.html_safe, {:controller => "portfolio_group", :action => 'destroy', :id => id}, :confirm => "Are you sure you want to Delete", :method => :delete,:class=>"icon-large icon-trash"
  end

  def select_list
    [["Year 1",1],
     ["Year 2",2],
     ["Year 3",3],
     ["Year 4",4],
     ["Year 5",5],
     ["Year 6",6],
     ["Year 7",7],
     ["Year 8",8],
     ["Year 9",9],
     ["Year 10",10],
     ]
  end

  def portfolio_status(portfolio_group)
    portfolio = PortfolioGroup.find(portfolio_group)
    if portfolio.status
      link_to "Deactivate", {:controller => "portfolio_group", :action => 'change_portfolio_status', :id => portfolio_group, :status=>false}
    else
      link_to 'Activate', {:controller => "portfolio_group", :action => 'change_portfolio_status', :id => portfolio_group, :status=>true}
    end
  end

  def get_status(portfolio)
    portfolio.status ? "Active" : "Inactive"
  end
end
