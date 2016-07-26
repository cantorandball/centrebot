class Outcome < ActiveRecord::Base
  belongs_to :question
  belongs_to :next_question, class_name: "Question"

  TYPES = %w(MultipleChoiceOutcome
             DateOutcome
             NoTextOutcome).freeze

  validates :value, length: { maximum: 140 }

  ResetKeyword = "restart".freeze

  def correct_period?(incoming_date)
    is_correct = true
    if lower_bound
      is_correct = false if incoming_date <= Date.today.prev_year(lower_bound)
    end
    if upper_bound
      is_correct = false if incoming_date > Date.today.prev_year(upper_bound)
    end
    is_correct
  end
end
