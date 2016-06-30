class AnswersController < ApplicationController
  def show
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
  end

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    redirect_to edit_question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:text)
  end
end
