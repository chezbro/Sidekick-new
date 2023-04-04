class ConfirmationsController < ApplicationController
  def new
    
  end

  def create
    @user = User.find_by(phone_number: session[:phone_number])
    if @user.code == params[:code]
      @user.update(verified: true)
      session[:user_id] = @user.id
      session.delete(:phone_number)
      redirect_to conversations_path
    else
      flash.now[:alert] = "Invalid verification code"
      render :new
    end
  end
end
