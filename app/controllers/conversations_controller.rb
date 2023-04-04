# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  # before_action :authenticate_user!, except: [:incoming_sms]
  skip_before_action :verify_authenticity_token, only: [:incoming_sms]

  # def index
  #   @conversation = Conversation.find_or_create_by(user_id: current_user.id)
  #   @message = Message.new(user_id: current_user.id, conversation_id: @conversation)
  #   @conversations = current_user.conversations.includes(:messages)

  # end
  
  def index
    @conversation = Conversation.find_or_create_by(user_id: current_user.id)
    @conversations = current_user.conversations
    @message = Message.new(user_id: current_user.id, conversation_id: @conversation)
    # @conversations = current_user.conversations.includes(:messages)    
  end


  def create
    @conversation = current_user.conversations.create
    @conversation.messages.create(content: params[:message], user: current_user)
    redirect_to conversation_path(@conversation)
  end
  
  def edit
    
  end

  def new
    @conversation = current_user.conversations.new
    @message = @conversation.messages.new
    @messages = @conversation.messages.order(created_at: :asc)
  
    # if @conversation.save
    #   redirect_to conversation_messages_path(@conversation)
    # else
    #   flash[:error] = "Unable to create conversation."
    #   redirect_to conversations_path
    # end
  end



  def show
    
    @conversation = current_user.conversations.find(params[:id])
      #   @conversation = Conversation.find_or_create_by(user_id: current_user.id)
    @message = Message.new(user_id: current_user.id, conversation_id: @conversation)
  #   @conversations = current_user.conversations.includes(:messages)
  end

  # def incoming_sms
  #   from_number = params[:From]
  #   body = params[:Body]
    
  #   # Find the conversation associated with the incoming phone number
  #   @conversation = Conversation.find_by(phone_number: from_number).first

  #   # If no conversation is found, create a new one
  #   unless @conversation
  #     user = User.find_by(phone_number: from_number)
  #     @conversation = user.conversations.create(phone_number: from_number)
  #     @conversation.messages.create(user: user, body: "Hello! How can I help you?")
  #   end

  #   # Send the message to the chatbot and save the response to the database
  #   message = @conversation.messages.create(user: current_user, body: body)
  #   response = GPTChatbot.generate_response(body)
  #   @conversation.messages.create(user: @conversation.bot_user, body: response)

  #   # Send the response back to the user via SMS
  #   twilio_service = TwilioService.new
  #   twilio_service.send_sms(to: from_number, body: response)
  # end
end
