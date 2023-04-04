class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token

  # def voice
  #   response = Twilio::TwiML::VoiceResponse.new do |r|
  #     r.say('Hello from your Rails app!')
  #   end

  #   render xml: response.to_s
  # end

  def sms
    from_number = params['From']
    message_body = params['Body']

    # Handle the incoming SMS message and generate a response
    response_body = "Received message from #{from_number}: #{message_body}"
    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message(body: response_body)
    end

    render xml: twiml.to_s
  end
end

