class QuestionCategoryController < ApplicationController

  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(5)}

  def index
    @question_categories = QuestionCategory.all
  end

  def new
    @question_category = QuestionCategory.new
  end

  def create
    @question_category = QuestionCategory.new(params[:question_category])
    if @question_category.save
      flash[:notice] = "Category created"
      redirect_to admin_cms_faq_category_path
    else
      flash[:error] = @question_category.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def edit
    @question_category = QuestionCategory.find params[:id]
  end

  def update
    @question_category = QuestionCategory.find params[:question_category][:id]
    if @question_category.update_attributes params[:question_category]
      flash[:notice] = "Succesfully updated"
      redirect_to admin_cms_faq_category_path
    else
      flash[:error] = @question_category.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def destroy
    @question_category = QuestionCategory.find params[:id]
    if @question_category.destroy
      flash[:notice] = "Deleted"
    else
      flash[:error] = @question_category.errors.full_messages.to_sentence
    end
    redirect_to admin_cms_faq_category_path
  end

end
