class Outcome < ActiveRecord::Base
  belongs_to :question
  belongs_to :next_question, class_name: "Question"

  validates :value, presence: true
  validates :value, length: { maximum: 140 }
end
