module UserHelper

  def sign_in_path
    '/'
  end

  def edit_user_profile(id)
    link_to "&nbsp".html_safe ,{:controller => 'users' , :action => 'edit' ,:id => id} , :class=>"icon-large icon-pencil"
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end

  def method_name(time)
    d= time
    d.strftime(" %H hours and %M minutes")

  end

  def distance_of_time_in_hours_and_minutes(from_time , to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_hours   = (((to_time - from_time  ).abs) / 3600).round
    distance_in_minutes = ((((to_time - from_time ).abs) % 3600) / 60).round

    difference_in_words = ''

    difference_in_words << "#{distance_in_hours} #{distance_in_hours > 1 ? 'hours' : 'hour' } and " if distance_in_hours > 0
    difference_in_words << "#{distance_in_minutes} #{distance_in_minutes == 1 ? 'minute' : 'minutes' }"
  end

end
