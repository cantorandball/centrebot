class InvalidEmailError < StandardError
end

class EmailQuestion < Question
  def parse(incoming_text)
    email_regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
    lower_text = incoming_text.downcase
    error_message = "Sorry, that didn't seem to be a valid email address. "\
                    "Could you try entering it again?"
    if email_regex !~ lower_text
      raise InvalidEmailError.new(error_message)
    end
  end
end
