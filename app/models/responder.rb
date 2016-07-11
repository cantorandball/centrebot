class Responder < ActiveRecord::Base
  Initial = "initial".freeze
  Active = "active".freeze
  Completed = "completed".freeze

  States = [Initial, Active, Completed].freeze

  has_many :answers, dependent: :destroy

  validates :state, inclusion: { in: States }
  validates :source, presence: true, inclusion: { in: %w(sms) }
  validates :identifier, presence: true

  after_initialize :set_initial_state

  def state?(comp)
    state == comp
  end

  def previous_question
    questions.last
  end

  def previous_answer
    answers.last
  end

  def current_question
    previous_question.outcome_for(previous_answer).try(:next_question)
  end

  def answer(question, message)
    answers.create(text: message, question_text: question.text)
  end

  private

  def set_initial_state
    self.state ||= Responder::Initial
  end
end
