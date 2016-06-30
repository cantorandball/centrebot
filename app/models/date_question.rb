class DateQuestion < Question
  def parse(incoming_text)
    incoming_parsed_text = super
    date_format = '%d.%m.%Y'
    dividers = '([:-|/\\\\ .])'
    day_match = '(?<day>[0-9]{1,2})'
    month_match = '(?<month>[0-9]{1,2})'
    year_match = '(?<year>[0-9]{4})'
    date_match = "#{day_match}#{dividers}#{month_match}#{dividers}#{year_match}"
    matched_date = incoming_parsed_text.match(date_match)
    if matched_date
    else
    end
  end
end
