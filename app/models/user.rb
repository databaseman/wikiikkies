class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :secure_validatable

  validates :name,  presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 8 }, allow_blank: true #blank for when not changing password

  before_save { self.email = email.downcase if email.present? }

  default_scope { order(email: :asc) }
end
