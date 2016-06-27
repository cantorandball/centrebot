class EmailQuestion < Question
  def parse(incoming_text)
    email_regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
    lower_text = incoming_text.downcase
    if email_regex !~ lower_text
      raise InvalidInputError.new()
    end
  end
end
