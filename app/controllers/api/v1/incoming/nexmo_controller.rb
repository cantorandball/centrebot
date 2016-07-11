module Api
  module V1
    module Incoming
      class NexmoController < BaseController
        def create
          identifier = params[:msisdn]
          incoming_message = params[:text]

          responder = Responder.find_or_create_by(source: "sms",
                                                  identifier: identifier)
          handler = MessageHandler.new(responder, incoming_message)

          m = handler.valid? ? handler.next_response : handler.error_response

          NexmoClient.send_message(to: identifier, text: m)

          render json: { "message" => m }
        end
      end
    end
  end
end
