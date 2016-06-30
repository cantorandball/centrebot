class DateQuestion < Question
  def parse(incoming_text)
    incoming_parsed_text = super
    out_format = "%d.%m.%Y"
    begin
      in_date = Date.parse(incoming_parsed_text)
    rescue ArgumentError
      raise(InvalidInputError)
    end
    in_date.strftime(out_format)
  end
end
