class HomeController < ApplicationController
  
  def index
  end
  
  def home
    @user = User.new
  end

  def verify
    phone_number = params[:user][:phone_number]
    @user = User.find_by(phone_number: phone_number)

    if @user
      code = rand(100000..999999)
      @user.update(code: code)
      message = "Your verification code is #{code}"
      TwilioService.send_message(phone_number, message)
      redirect_to verification_path(phone_number: phone_number)
    else
      @user = User.new(user_params)
      @user.code = rand(100000..999999)
      if @user.save
        message = "Your verification code is #{@user[:code]}"
        TwilioService.send_message(phone_number, message)
        redirect_to verification_path(phone_number: phone_number)
      else
        render 'home'
      end
    end
  end

  def verification
    @phone_number = params[:phone_number]
  end

  def check_verification
    phone_number = verification_params[:phone_number]
    code = verification_params[:code]

    if User.exists?(phone_number: phone_number, code: code, verified: false)
      @user = User.find_by(phone_number: phone_number, code: code, verified: false)
      @user.verified = true
      @user.save
      flash[:success] = 'Phone number verified!'
      redirect_to conversations_path
    else
      flash[:alert] = 'Incorrect verification code'
      render 'verification'
    end
  end

  def conversations
  end

  def send_message
    message = params[:message]
    twilio_number = ENV['TWILIO_TEST_PHONE_NUMBER']
    begin
      client = Twilio::REST::Client.new
      client.messages.create({
        from: twilio_number,
        to: current_user.phone_number,
        body: message
      })
      flash[:success] = 'Message sent'
      redirect_to conversations_path
    rescue Twilio::REST::TwilioError => e
      flash[:alert] = 'Failed to send message'
      redirect_to conversations_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number, :password, :password_confirmation)
  end

  def verification_params
    params.permit(:phone_number, :code)
  end
end
