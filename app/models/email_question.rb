class EmailQuestion < Question
  def parse(incoming_text)
    initial_parsed_text = super
    if initial_parsed_text == Outcome::ResetKeyword
      Outcome::ResetKeyword
    end

    email_regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
    if email_regex !~ initial_parsed_text
      raise InvalidInputError.new
    else
      initial_parsed_text
    end
  end
end
