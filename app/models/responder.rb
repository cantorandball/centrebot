class Responder < ActiveRecord::Base
  Initial = "initial".freeze
  Active = "active".freeze
  Completed = "completed".freeze

  States = [Initial, Active, Completed].freeze

  has_many :answers, dependent: :destroy
  has_many :questions, through: :answers

  validates :state, inclusion: { in: States }
  validates :source, presence: true, inclusion: { in: %w(sms) }
  validates :identifier, presence: true

  after_initialize :set_initial_state

  def previous_question
    questions.last
  end

  def previous_answer
    answers.last
  end

  def current_question
    previous_question.outcome_for(previous_answer).try(:next_question)
  end

  private

  def set_initial_state
    self.state ||= Responder::Initial
  end
end
