class OutcomesController < ApplicationController
  def show
    @question = Question.find(params[:question_id])
    @answer = @question.outcomes.create(outcome_params)
  end

  def new
    @outcome = Outcome.new
  end

  def create
    @question = Question.find(params[:question_id])
    @outcome = @question.outcomes.create(outcome_params)
    redirect_to edit_question_path(@question)
  end

  private

  def outcome_params
    params.require(:outcome).permit(:text, :next_question)
  end
end
