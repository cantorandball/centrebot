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
    responder.identifier ? fetch_response : first_response
  end


  def fetch_response
    return nil unless valid?
    responder.state == Responder::Initial ? initial_response : active_response
  end

  def initial_response
    responder.state = Responder::Active
    responder.save!
    [Question.first.text]
  end

  def active_response
    response = []
    current_question.answer(responder, incoming_message)
    outcome = responder.previous_question.outcome_for(incoming_message)

    if outcome.message
      response.push(outcome.message)
    end

    if outcome.next_question
      response.push(outcome.next_question.text)
    else
      responder.state = Responder::Completed
      responder.save!
      if outcome.message.blank?
        response.push(terminating_statement)
      end
    end
    response
  end

  def error_response
    [
      ["Sorry, I didn't quite get that. Could you try again?"],
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

  def first_response
    "First response to a responder without an identifier"
  end
end
