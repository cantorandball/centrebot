class Question < ActiveRecord::Base
  has_many :answers

  validates :text, presence: true
  validates :text, length: { maximum: 140 }
end
