class Question < ActiveRecord::Base
  TYPES = %w(DateQuestion
              EmailQuestion
              MultipleChoiceQuestion
              OpenTextQuestion
              PhoneQuestion).freeze

  has_many :answers
  has_many :outcomes

  accepts_nested_attributes_for :answers

  validates :text, presence: true
  validates :text, length: { maximum: 140 }

  def outcome_for(answer)
    outcomes.where(value: answer.text).first
  end

  def answer(responder, message)
    answers.create(responder: responder, text: message)
  end
end
