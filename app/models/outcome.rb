class Outcome < ActiveRecord::Base
  belongs_to :question
  belongs_to :next_question, class_name: "Question"

  TYPES = %w(MultipleChoiceOutcome
             DateOutcome
             NoTextOutcome)

  validates :value, length: { maximum: 140 }

  ResetKeyword = "restart".freeze

end
