class DateQuestion < Question
  def outcome_type
    "DateOutcome"
  end

  def outcome_for(incoming_text)
    if incoming_text.downcase == Outcome::ResetKeyword
      puts "Restarting"
      Outcome.new(next_question: Question.first)
    else
      parsed_date = Date.parse(parse(incoming_text))
      valid_outcomes = []
      outcomes.each do |outcome|
        if outcome.correct_period?(parsed_date)
          valid_outcomes.push(outcome)
        end
      end
      valid_outcomes.first
    end
  end

  def parse(incoming_text)
    incoming_parsed_text = super

    if incoming_parsed_text == Outcome::ResetKeyword
      Outcome::ResetKeyword
    else
      out_format = "%d.%m.%Y"
      begin
        in_date = Date.parse(incoming_parsed_text)
      rescue ArgumentError
        raise(InvalidInputError)
      end
      in_date.strftime(out_format)
    end
  end
end
