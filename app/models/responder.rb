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

  def state?(comp)
    state == comp
  end

  def previous_question
    previous_answer.question
  end

  def previous_answer
    answers.last
  end

  def current_question
    if previous_question.valid_answer?(previous_answer.text)
      previous_question.outcome_for(previous_answer.text).try(:next_question)
    else
      previous_question
    end
  end

  def initial_answer(message)
    if Question.find_by(text: "First contact:")

    end

    answers.create(question: initial_q, text: message)
  end

  private

  def set_initial_state
    self.state ||= Responder::Initial
  end
end
