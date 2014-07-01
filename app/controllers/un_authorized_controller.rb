class UnAuthorizedController < ApplicationController
  def index
    @path = params[:id]
  end
end
