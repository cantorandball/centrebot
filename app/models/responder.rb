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
    initial_text = "First contact:"
    initial_question = Question.find_by(text: initial_text)
    if initial_question.nil?
      initial_question = Question.create(type: "OpenTextQuestion",
                                         text: initial_text)
      initial_question.outcomes.create(next_question: Question.all.first)
    end
    answers.create(question: initial_question,
                   text: message,
                   question_text: initial_text)
  end

  private

  def set_initial_state
    self.state ||= Responder::Initial
  end
end
