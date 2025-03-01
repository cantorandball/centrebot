module Api
  module V1
    module Incoming
      class NexmoController < BaseController
        def create
          @identifier = params[:msisdn]
          incoming_message = params[:text]

          responder = Responder.find_or_create_by(source: "sms",
                                                  identifier: @identifier)
          handler = MessageHandler.new(responder, incoming_message)

          r = handler.valid? ? handler.next_response : handler.error_response

          render_responses r
        end

        def render_responses(responses)
          rendered_messages = []

          responses.each do |message|
            NexmoClient.send_message(to: @identifier, text: message)
            rendered_messages.push(message)
          end

          render json: { "messages" => rendered_messages }
        end
      end
    end
  end
end
