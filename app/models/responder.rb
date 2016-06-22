class Responder < ActiveRecord::Base
  has_many :answers
  has_many :questions, through: :answers

  def previous_question
    questions.last
  end

  def previous_answer
    answers.last
  end

  def current_question
    previous_question.outcome_for(previous_answer).next_question
  end
end
