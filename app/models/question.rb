class Question < ActiveRecord::Base
  validates :text, presence: true
  validates :text, length: { maximum: 140 }
end
