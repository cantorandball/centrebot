class Answer < ActiveRecord::Base
  belongs_to :responder
  belongs_to :question
end
