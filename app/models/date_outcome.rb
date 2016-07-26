class DateOutcome < Outcome
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
