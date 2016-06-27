module Api
  module V1
    module Incoming
      class NexmoController < BaseController
        def create
          identifier = params[:msisdn]
          incoming_message = params[:text]

          handler = IncomingMessageHandler.new("sms", identifier)
          message = handler.run(incoming_message)

          NexmoClient.send_message(to: identifier, text: message)

          render json: { "message" => message }
        end
      end
    end
  end
end
