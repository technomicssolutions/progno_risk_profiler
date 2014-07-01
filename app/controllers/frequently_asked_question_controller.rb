class FrequentlyAskedQuestionController < ApplicationController

  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(5)}

  def index
    @question_category = QuestionCategory.all
    @frequently_asked_questions =FrequentlyAskedQuestion.published
  end

  def show
    @frequently_asked_questions = FrequentlyAskedQuestion.where(:category_id => params[:cat]).published
  end
  def edit
    @question_category = QuestionCategory.all
    @frequently_asked_question = FrequentlyAskedQuestion.find(params[:id])
  end

  def new
    @question_category = QuestionCategory.all
    @frequently_asked_question = FrequentlyAskedQuestion.new
  end

  def destroy
    @frequently_asked_question = FrequentlyAskedQuestion.find(params[:id])
    if @frequently_asked_question.destroy
      flash[:notice] = "Deleted succesfully"
    else
      flash[:error] = @frequently_asked_question.errors.full_messages.to_sentence
    end
    redirect_to  admin_cms_faq_unpublish_path
  end

  def update
    @frequently_asked_question = FrequentlyAskedQuestion.find(params[:frequently_asked_question][:id])
    if @frequently_asked_question.update_attributes params[:frequently_asked_question]
      flash[:notice] = "Succesfully updated"
      redirect_to admin_cms_faq_path
    else
      flash[:error] = @frequently_asked_question.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def create
    @question_category = QuestionCategory.all
    @frequently_asked_question = FrequentlyAskedQuestion.new(params[:frequently_asked_question])
    if @frequently_asked_question.save
      flash[:notice] = "succesfully created"
      redirect_to admin_cms_faq_path
    else
      flash[:error]= @frequently_asked_question.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def unpublish
    @frequently_asked_questions = FrequentlyAskedQuestion.unpublished
  end
  def guest
    @question_category = QuestionCategory.all
    @frequently_asked_questions = FrequentlyAskedQuestion.published
  end
  def admin_view
    @question_category = QuestionCategory.all
    @frequently_asked_questions = FrequentlyAskedQuestion.where(:category_id => params[:cat]).published
  end
  def destroy_from_category

    @frequently_asked_question = FrequentlyAskedQuestion.find(params[:id])
    if @frequently_asked_question.destroy
      flash[:notice]="Deleted Succesfully"
    else
      flash[:error] = @frequently_asked_question.errors.full_messages.to_sentence
    end
    redirect_to admin_cms_faq_path

  end
end
