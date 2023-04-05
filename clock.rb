require 'clockwork'
require 'twilio-ruby'
require 'httparty'
require 'airrecord'


# set up the Twilio client
account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']
twilio_number = ENV['TWILIO_PHONE_NUMBER']
# @client = TwilioService.new
# set up the Clockwork scheduler
module Clockwork
  handler do |job|
    case job
    when 'send_motivational_quotes'
      # send motivational quotes to all users
      send_motivational_quotes
    end
  end

  # run this job every day at 10am EST
  every(1.day, 'send_motivational_quote', at: '10:00', tz: 'EST')
end

def send_motivational_quotes
  # fetch a random quote from the Zenquotes API
  quote = HTTParty.get('https://zenquotes.io/api/random').parsed_response.first

  # get a list of all phone numbers from the 'data' table in Airtable
  # airtable = Airtable::Client.new(ENV['AIRTABLE_API_KEY'])
  # data_table = airtable.table(ENV['AIRTABLE_BASE_ID'], 'data')
  # phone_numbers = data_table.all(fields: ['phone_number']).map { |r| r['fields']['phone_number'] }
  phone_numbers = ["+12486322108", "+12486322109"]
  
  # send the quote to each user via SMS
  phone_numbers.each do |phone_number|
    message = "Good morning! Here's your motivational quote for the day:\n\n#{quote['q']}\n- #{quote['a']}"
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_TEST_ACCOUNT_SID'],
      ENV['TWILIO_TEST_AUTH_TOKEN']
    )
    
    @client.messages.create(from: ENV['TWILIO_PHONE_NUMBER'], to: phone_number, body: message)
  end
  
end