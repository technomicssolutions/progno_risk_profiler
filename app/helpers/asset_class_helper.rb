module AssetClassHelper
  def new_asset_class
    link_to "Add Row", {:controller => 'asset_class', :action => 'new'}, :remote => true,:class=>"icon-large icon-plus"
  end

  def edit_asset_class(id)
    link_to '&nbsp;'.html_safe, {:controller => 'asset_class',:action => 'edit', :id => id}, :method => 'post', :remote => true,:class=>"icon-large icon-pencil"
  end

  def delete_asset_class(id)
    link_to '&nbsp;'.html_safe, {:controller => "asset_class", :action => 'destroy', :id => id}, :confirm => "Are you sure you want to Delete", :method => :delete,:class=>"icon-large icon-trash"
  end

  def flush_asset_class(id)
    link_to '&nbsp;'.html_safe, {:controller => "asset_class", :action => 'flush_data', :id => id}, :confirm => "Are you sure you flush the pre existing data", :method => :delete,:class=>"icon-large icon-remove"
  end

  def set_rolling_time_period
    link_to "Set New Time Period", {:controller => 'asset_class', :action => 'rolling_time_period_new'}, :remote => true,:class=>"icon-large icon-plus"
  end

  def edit_rolling_time_period(id)
    link_to '&nbsp;'.html_safe, {:controller => 'asset_class',:action => 'rolling_time_period_edit', :id => id}, :method => 'post', :remote => true,:class=>"icon-large icon-pencil"
  end

  def delete_rolling_time_period(id)
    link_to '&nbsp;'.html_safe, {:controller => "asset_class", :action => 'rolling_time_period_delete', :id => id}, :confirm => "Are you sure you want to Delete", :method => :delete,:class=>"icon-large icon-trash"
  end

  def asset_allocation(time_period)
    asset_allocation_id = time_period.rolling_period_added.to_s
    asset_allocation_id << "-" + time_period.return_units_no.to_s
    asset_allocation_id << "-" + time_period.data_unit.to_s
  end

  def asset_class_name(id)
    AssetClass.find(id).main_asset_class if id
  end

  def select_rolling_period(time_period)
    link_to "Select", {:controller => 'asset_class', :action => 'view_matrics_stats', :id => time_period}, :remote => true
  end

  def update_view_matrics(id)
    link_to 'Update'.html_safe, {:controller => 'asset_class',:action => 'update_view_matrics', :id => id}, :method => 'post'
  end

  def find_correllation(object,i,j)
    correlation = object.find(:all, :conditions=>{:asset_class_item_one_id => i,:asset_class_item_two_id => j})
  end

  def download_data(id,name)
    link_to "Download", "/admin/investment/asset_class/download_stats/#{id.id}/#{name}.xls"
  end
end
