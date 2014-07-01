class SiteContentController < ApplicationController

  def index
    @site_contents = SiteContent.all
  end

  def new
    @site_content = SiteContent.new
  end

  def create
    @site_content = SiteContent.new(params[:site_content])
    respond_to do |format|
      if @site_content.save
        flash[:notice] = 'Content was successfully created.'
        format.html { redirect_to site_content_path }
      else
        flash[:error] = @site_content.errors.full_messages.to_sentence
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @site_content = SiteContent.find params[:id]
  end

  def update
    @site_content = SiteContent.find params[:site_content][:id]
    respond_to do |format|
      if @site_content.update_attributes params[:site_content]
        flash[:notice] = "Successfully updated..."
        format.html { redirect_to site_content_path }
      else
        flash[:error] = @site_content.errors.full_messages.to_sentence
        format.html { render :action => "edit" }
      end
    end
  end

  def show
    @site_content = SiteContent.find params[:id]
  end

  def page
    @site_content = SiteContent.page params[:url]
  end
end
