class MultipleChoiceQuestion < Question
  class MultipleChoiceOption
    def initialize(input_text)
      @input_text = input_text
    end

    def number
      number_match = /(^[0-9]+)/
      @input_text[number_match, 1]
    end

    def text
      text_match = /(?:[0-9]+.? +)?(.+)/
      @input_text[text_match, 1]
    end
  end

  def outcome_for(answer_text)
    if answer_text == Outcome::ResetKeyword
      Outcome.new(next_question: Question.first)
    else
      answer_value = parse(answer_text)
      outcomes.where(value: answer_value).first
    end
  end

  def parse(incoming_text)
    matched_outcome = false
    incoming_parsed_text = super

    if incoming_parsed_text == Outcome::ResetKeyword
      matched_outcome = incoming_parsed_text
    else
      incoming_option = MultipleChoiceOption.new incoming_parsed_text
      outcomes.each do |outcome|
        parsed_outcome = super outcome.value
        outcome_option = MultipleChoiceOption.new parsed_outcome
        if incoming_parsed_text == parsed_outcome ||
            incoming_option.text == outcome_option.text
          matched_outcome = outcome.value
        elsif incoming_option.number &&
            incoming_option.number == outcome_option.number
          matched_outcome = outcome.value
        end
      end
    end

    if matched_outcome
      matched_outcome
    else
      raise InvalidInputError.new
    end
  end
end
