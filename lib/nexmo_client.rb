require "nexmo"

class NexmoClient
  attr_reader :client

  def initialize
    @client = Nexmo::Client.new(key: ENV["NEXMO_API_KEY"],
                                secret: ENV["NEXMO_API_SECRET"])
  end

  class << self
    def send_message(args = {})
      nexmo_client = new

      default_args = { from: ENV["NEXMO_PHONE_NUMBER"] }
      message_hash = default_args.merge(args)

      nexmo_client.client.send_message(message_hash)
    end
  end
end
