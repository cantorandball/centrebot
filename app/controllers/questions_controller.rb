class QuestionsController < ApplicationController
  def index
    @questions = Question.all.where(archived: false).order(:id)
  end

  def new
    @question = Question.new
    @question.outcomes.build
  end

  def edit
    @question = Question.find(params[:id])
    @other_questions = []
    Question.all.each do |question|
      if question != @question && !question.archived
        @other_questions.append question
      end
    end
  end

  def create
    @question = Question.new question_params

    if @question.save
      flash[:notice] = "Question created"
      redirect_to questions_path
    else
      if @question.errors.any?
        @question.errors.full_messages.each do |error|
          flash[:error] = error
        end
      end
      render "new"
    end
  end

  def update
    @question = Question.find(params[:id])

    @other_questions = []
    Question.all.each do |question|
      if question != @question && !question.archived
        @other_questions.append question
      end
    end

    if @question.update(question_params)
      flash[:notice] = "Question updated"
      redirect_to edit_question_path(@question)
    else
      if @question.errors.any?
        @question.errors.full_messages.each do |error|
          flash[:error] = error
        end
      end
      render "edit"
    end
  end

  def archive
    @question = Question.find(params[:question_id])

    if @question.update_attribute(:archived, true)
      flash[:notice] = "Question archived"
      redirect_to questions_path
    else
      if @question.errors.any?
        @question.errors.full_messages.each do |error|
          flash[:error] = error
        end
      end
      render "index"
    end
  end

  private

  def question_params
    params.require(:question).permit(:text,
                                     :type,
                                     outcomes_attributes: [:id, :value,
                                                           :message,
                                                           :next_question_id,
                                                           :_destroy,
                                                           :lower_bound,
                                                           :upper_bound])
  end
end
