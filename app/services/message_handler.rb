class MessageHandler
  attr_reader :responder, :incoming_message

  def initialize(responder, incoming_message)
    @responder = responder
    @incoming_message = incoming_message
  end

  def valid?
    return true if responder.state?(Responder::Initial)
    return true if current_question.valid_answer?(incoming_message)

    false
  end

  def next_response
    return nil unless valid?
    if responder.state == Responder::Initial
      responder.state = Responder::Active
      responder.save!
      return Question.first.text
    end

    answer = current_question.answer(responder, incoming_message)
    outcome = responder.previous_question.outcome_for(answer)

    if outcome.next_question
      outcome.next_question.text
    else
      responder.state = Responder::Completed
      responder.save!
      if outcome.message
        outcome.message
      else
        terminating_statement
      end
    end
  end

  def error_response
    [
      "Sorry, I didn't quite get that. Could you try again?",
    ].sample
  end

  def terminating_statement
    "You've reached the end!"
  end

  private

  def first_question
    Question.first
  end

  def current_question
    responder.answers.empty? ? first_question : responder.current_question
  end
end
