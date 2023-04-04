class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_TEST_ACCOUNT_SID'],
      ENV['TWILIO_TEST_AUTH_TOKEN']
    )
  end

  def send_message(to, body)
    from = ENV['TWILIO_TEST_PHONE_NUMBER']
    @client.messages.create(
      from: from,
      to: to,
      body: body
    )
  end

  def send_verification_code(to, code)
    message = @client.messages.create(
      from: ENV['TWILIO_TEST_PHONE_NUMBER'],
      to: to,
      body: "Your verification code is #{code}"
    )
    message.sid
  end
end
