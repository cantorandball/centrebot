class PhoneQuestion < Question
  def parse(incoming_text)
    initial_parsed_text = super
    if Phonelib.valid_for_country? initial_parsed_text, "GB"
      initial_parsed_text
    else
      raise InvalidInputError.new()
    end
  end
end
