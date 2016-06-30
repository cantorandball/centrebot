class MultipleChoiceQuestion < Question
  def parse(incoming_text)
    number_match = /(^[0-9]+)/
    text_match = /(?:[0-9]+.? +)?(.+)/
    matched_outcome = false
    incoming_parsed_text = super
    incoming_number = incoming_parsed_text[number_match, 1]
    incoming_text = incoming_parsed_text[text_match, 1]
    outcomes.each do |outcome|
      parsed_outcome = super outcome.value
      outcome_number = parsed_outcome[number_match, 1]
      outcome_text = parsed_outcome[text_match, 1]
      if parsed_outcome == incoming_parsed_text or
         outcome_number == incoming_number or
         outcome_text == incoming_text
        matched_outcome = outcome.value
      end
    end

    if matched_outcome
      matched_outcome
    else
      raise InvalidInputError.new "#{incoming_text} is invalid"
    end
  end
end
