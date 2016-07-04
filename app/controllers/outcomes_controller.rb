class OutcomesController < ApplicationController
  def new
    @outcome = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @outcome = @question.outcomes.create(outcome_params)
    @answer = @question.answers.create(answer_params)
    redirect_to edit_question_path(@question)
  end

  private

  def outcome_params
    params.require(:outcome).permit(:value, :next_question)
  end
end