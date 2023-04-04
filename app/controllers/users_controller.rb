class UsersController < ApplicationController
  before_action :require_login, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      code = rand(100_000..999_999)
      session[:phone_number] = @user.phone_number
      twilio = TwilioService.new
      twilio.send_verification_code(@user.phone_number, code)
      @user.code = code
      @user.save!
      redirect_to new_confirmation_path
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      redirect_to root_path
    end
  end

  def verify
    @user = User.find(session[:user_id])
    if request.post?
      twilio_service = TwilioService.new
      if twilio_service.verify_code(@user.phone_number, params[:code])
        @user.update_attribute(:verified, true)
        redirect_to conversations_path
      else
        flash.now[:alert] = 'Invalid verification code'
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :code, :phone_number, :password, :password_confirmation)
  end

  def require_login
    redirect_to root_url unless current_user
  end

  def format_phone_number
    # Only format the phone number if it's present and not already formatted
    if phone_number.present? && !phone_number.match?(/\A\+\d{1,3}\s\d{1,14}\z/)
      formatted_number = Phonelib.parse(phone_number, default_country).full_e164
      self.phone_number = formatted_number
    end
  end  
end
