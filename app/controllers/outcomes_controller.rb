class OutcomesController < ApplicationController
  def list
    @questions = Question.all
  end
end