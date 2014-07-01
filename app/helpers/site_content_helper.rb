module SiteContentHelper

  def new_page
    link_to "Add page", {:controller => 'site_content', :action => 'new'}
  end

  def title_link(content)
    link_to "#{content.page_url}", {:controller => 'site_content', :action => 'show', :id => content.id}
  end

  def page_links(content)
    link_to "Edit page", {:controller => 'site_content', :action => 'edit', :id => content.id}
  end

  def page_published(content)
    published = SiteContent.find(content.id).published
    published ? "Published" : "Unpublished"
  end

  def display_content(content)
    truncated_content = truncate content.content, :length =>1000
  end

  def read_more(content)
    link_to "Read more", {:controller => 'site_content', :action => 'show', :id => content.id}
  end
end
