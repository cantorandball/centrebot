module Api
  module V1
    module Incoming
      class NexmoController < BaseController
        def create
          identifier = params[:msisdn]
          incoming_message = params[:text]

          prior_responder = Responder.find_by(source: "sms",
                                              identifier: identifier)

          if prior_responder
            if prior_responder.answers.empty?
              current_question = Question.first
            else
              current_question = prior_responder.current_question
            end

            if current_question
              answer = current_question.answers.create(
                responder: prior_responder, text: incoming_message,
              )

              outcome = current_question.outcome_for(answer)

              message = if outcome
                          outcome.next_question.text
                        else
                          "You've reached the end!"
                        end
            else
              message = "You've reached the end!"
            end
          else
            first_question = Question.first
            message = first_question.text

            Responder.create(source: "sms", identifier: identifier)
          end

          NexmoClient.send_message(to: identifier, text: message)

          render json: { "message" => message }
        end
      end
    end
  end
end
