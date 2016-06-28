class InvalidInputError < StandardError
  def initialize(msg = "Sorry, I didn't quite get that answer. "\
                        "Could you try again?")
    super
  end
end

class Question < ActiveRecord::Base
  has_many :answers
  has_many :outcomes

  validates :text, presence: true
  validates :text, length: { maximum: 140 }

  def outcome_for(answer)
    outcomes.where(value: answer.text).first
  end

  def parse(incoming_text)
    incoming_text.downcase
  end

  def answer(responder, message)
    answers.create(responder: responder, text: message)
  end
end
