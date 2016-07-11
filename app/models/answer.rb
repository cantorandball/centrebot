class Answer < ActiveRecord::Base
  belongs_to :responder

  validates :question_text, presence: true

end
