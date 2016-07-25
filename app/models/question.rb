class InvalidInputError < StandardError
  def initialize(msg = "Sorry, I didn't quite get that answer. "\
                        "Could you try again?")
    super
  end
end

class Question < ActiveRecord::Base
  TYPES = %w(DateQuestion
             EmailQuestion
             MultipleChoiceQuestion
             OpenTextQuestion
             PhoneQuestion).freeze

  has_many :answers
  has_many :outcomes, dependent: :destroy

  accepts_nested_attributes_for :outcomes, allow_destroy: true

  validates :text, presence: true

  def outcome_type
    :outcomes
  end

  def outcome_for(answer_text)
    if answer_text == Outcome::ResetKeyword
      Outcome.new(next_question: Question.first)
    else
      outcomes.first
    end
  end

  def valid_answer?(incoming_message)
    parse(incoming_message)
    true
  rescue InvalidInputError
    false
  end

  def parse(incoming_text)
    incoming_text.downcase
  end

  def answer(responder, message)
    answers.create(responder: responder,
                   text: message,
                   question_text: text)
  end

  def describe
    "#{id}: #{text}"
  end

  def archive
    update_attribute(:archived, true)
  end
end
