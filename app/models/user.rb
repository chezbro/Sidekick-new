class User < ApplicationRecord
  has_many :conversations, dependent: :destroy
  has_secure_password
  validates :phone_number, presence: true, uniqueness: true
  before_validation :format_phone_number

  def format_phone_number
    self.phone_number = Phonelib.parse(phone_number).full_e164
  end

  
end
