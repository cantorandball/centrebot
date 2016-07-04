class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.answers.build
  end

  def edit
    @questions = Question.all
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)

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

  private

  def question_params
    params.require(:question).permit(:text,
                                     :type,
                                     answers_attributes: [:id, :text])
  end
end
