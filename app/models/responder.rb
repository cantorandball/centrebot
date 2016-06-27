class Responder < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :questions, through: :answers

  validates :source, presence: true, inclusion: { in: %w(sms) }
  validates :identifier, presence: true

  def previous_question
    questions.last
  end

  def previous_answer
    answers.last
  end

  def current_question
    previous_question.outcome_for(previous_answer).try(:next_question)
  end
end
