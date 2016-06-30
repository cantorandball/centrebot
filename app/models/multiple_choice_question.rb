class MultipleChoiceQuestion < Question
  def parse(incoming_text)
    initial_parsed_text = super
    outcomes.each do |outcome|
    end
  end
end
