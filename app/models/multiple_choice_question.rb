class MultipleChoiceQuestion < Question
  def parse(incoming_text)
    initial_parsed_text = super
    matched_outcome = false
    outcomes.each do |outcome|
      parsed_outcome = super outcome.value
      outcome_number = outcome.value[/^[0-9]+/]
      answer_number = initial_parsed_text[/^[0-9]+/]
      if parsed_outcome == initial_parsed_text or
         outcome_number == answer_number
        matched_outcome = outcome.value
      end
    end

    if matched_outcome
      matched_outcome
    else
      raise InvalidInputError.new
    end
  end
end
