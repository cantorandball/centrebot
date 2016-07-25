class DateOutcome < Outcome
  TYPES = %w(AnyValid LessThan MoreThan Between).freeze

  validates :type, presence: true
end