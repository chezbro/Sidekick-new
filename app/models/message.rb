# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  def from_user?(message, current_user)
    message.user == current_user
  end  

  
end