class IncomingMessageHandler
  attr_reader :source, :identifier, :responder

  def initialize(source, identifier)
    @source = source
    @identifier = identifier
  end

  def run(message)
    @responder = Responder.find_by(source: "sms", identifier: identifier)

    if responder
      if current_question
        answer = current_question.answer(responder, message)
        outcome = responder.previous_question.outcome_for(answer)

        message = if outcome
                    outcome.next_question.text
                  else
                    terminating_statement
                  end
      else
        message = terminating_statement
      end
    else
      message = first_question.text
      Responder.create(source: "sms", identifier: identifier)
    end

    message
  end

  private

  def first_question
    Question.first
  end

  def terminating_statement
    "You've reached the end!"
  end

  def current_question
    responder.answers.empty? ? first_question : responder.current_question
  end
end
