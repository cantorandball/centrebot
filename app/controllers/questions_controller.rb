class QuestionsController < ApplicationController
  def index
    non_archived_questions = Question.all.where(archived: false)
    non_archived_questions.sort_by {|q| q.name}
    @questions = non_archived_questions
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
    @other_questions.sort_by {|q| q.describe }
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
                                     :tag,
                                     outcomes_attributes: [:id, :value,
                                                           :message,
                                                           :next_question_id,
                                                           :lower_bound,
                                                           :upper_bound,
                                                           :_destroy,])

  end
end
