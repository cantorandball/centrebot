class Question < ActiveRecord::Base
  has_many :answers
  has_many :outcomes

  validates :text, presence: true
  validates :text, length: { maximum: 140 }
end
