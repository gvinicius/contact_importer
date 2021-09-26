class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :username, uniqueness: true
  validates :email, :uniqueness => {:allow_blank => true}


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def email_required?
    false
  end
end
