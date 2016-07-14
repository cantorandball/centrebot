class Answer < ActiveRecord::Base
  belongs_to :responder
  belongs_to :question

  validates :question_text, presence: true
end
