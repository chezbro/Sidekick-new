class MessagesController < ApplicationController
  before_action :set_conversation, except: [:incoming_sms]
  # before_action :set_conversation_from_sms, only: [:incoming_sms]
  skip_before_action :verify_authenticity_token, only: [:incoming_sms]


  def index
  end

  def show
    @message = @conversation.messages.find(params[:id])
    
  end

  def new
    @message = @conversation.messages.new
  end

def create
  @message = @conversation.messages.new(message_params)
  @message.save!
  @message.user = current_user
  # Save the users message to the bot on airtable
  new_record = Data.create("content" => params[:message][:content], "user_id" =>  params[:message][:user_id].to_s, "conversation_id" =>   params[:conversation_id].to_s)  
  
  # If message is from the user, send it to GPT
    if @message.from_user?(@message, current_user)

    # Send the message to OpenAI GPT
    response = OpenaiService.send_message_to_gpt(@message.content)

    # Create a new message from the bot with the GPT response
    bot_message = @conversation.messages.new(content: response, user_id: User.where(admin: true).first.id, conversation_id: params[:conversation_id])

    if bot_message.save!
      # Saves to Airtable 
      new_record = Data.create("content" => bot_message.content, "user_id" =>  bot_message.user.id.to_s, "conversation_id" => bot_message.conversation_id.to_s)
      
      # Twilio SMS message
      client = TwilioService.new
      # Format phone number
      formatted_number = Phonelib.parse(current_user.phone_number, 'US').full_e164
      client.send_message(formatted_number, response)
      
      redirect_to conversation_path(@conversation) 
    else
      redirect_to root_path
    end
  else
    if @message.save
      new_record = Data.create("content" => @message.content, "user_id" =>  @message.user.id.to_s, "conversation_id" => @message.conversation_id.to_s)
      
      redirect_to conversation_path(@conversation) 
    else
      
      redirect_to root_path
    end
  end
end

  def incoming_sms
    # sms msg from user
    from_number = params[:From]
    # sms content sent from user
    body = params[:Body]

    # format number
    formatted_number = Phonelib.parse(params[:From], "US").full_e164

    # Find or create user from incoming sms phone number 
    user = User.find_or_create_by(phone_number: formatted_number)
    
    # Get conversation from user
    @conversation = user.conversations.first
    
    # Create and save sms message from user to DB
    message = @conversation.messages.create(user: user, content: body, conversation: @conversation)
    message.save!
    
    # Create airtable record
    new_record = Data.create("content" => body, "user_id" =>  user.id.to_s, "conversation_id" => @conversation.id.to_s)

    # Send the message to the chatbot
    response = OpenaiService.send_message_to_gpt(message.content)
    
    # Twilio SMS message
    client = TwilioService.new
    # Format phone number and send message from bot
    client.send_message(formatted_number, response)
    
    # Send msg from bot
    @conversation.messages.create(user: User.where(admin: true).first, content: response)

    redirect_to conversation_path(@conversation) 

  end



  def edit
    @message = @conversation.messages.find(params[:id])
  end

  def update
    @message = @conversation.messages.find(params[:id])

    if @message.update(message_params)
      redirect_to conversation_messages_path(@conversation), notice: 'Message updated!'
    else
      render :edit
    end
  end

  def destroy
    @message = @conversation.messages.find(params[:id])
    @message.destroy

    redirect_to conversation_messages_path(@conversation), notice: 'Message deleted!'
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  # def set_conversation_from_sms
  #   user = User.find_by_phone_number(params[:From])
  #   @conversation = user.conversations.first 
  # end 

  def message_params
    params.require(:message).permit(:content, :user_id, :conversation_id)
  end



  
end

