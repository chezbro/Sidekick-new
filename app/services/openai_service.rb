# app/services/openai_service.rb

require "openai"

class OpenaiService
  def generate_response(prompt)
   client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    response = client.completions(
      parameters: {
        model: 'text-davinci-003',
        prompt: prompt,
        max_tokens: 50,
        n: 1,
        stop: "\n"
      })
    # response.choices.first.text.strip
    response["choices"].map { |c| c["text"] }
  end

  def self.send_message_to_gpt(message)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    prompt = "User: #{message}\nBot:"
    response = client.completions(
      parameters: {
        model: 'text-davinci-003',
        prompt: prompt,
        max_tokens: 150,
        n: 1,
        stop: 'User:'
      })

    # bot_message = response.choices.first.text.strip
    # bot_message = response["choices"].map { |c| c["text"] }
    bot_message = response["choices"].map { |c| c["text"] }.first.gsub(/\([^()]*\)/, "").strip

    return bot_message
  end
  
end
