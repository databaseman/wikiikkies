class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :secure_validatable

  has_many :posts, dependent: :destroy
  has_many :assignments
  has_many :roles, through: :assignments #declared assigments method when calling @user.roles.assigments.build returns array of assigments

  validates :name,  presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 8 }, allow_blank: true #blank for when not changing password

  before_save { self.email = email.downcase if email.present? }
  before_destroy :destroy_assignments  # remove dependents first. Have to do this with has_many through

  default_scope { order(email: :asc) }

  # user.role?("premium")
  def role?(role)
    roles.any? { |r| r.name == role } # User can be assigned many roles
  end

  def destroy_assignments
    self.assignments.destroy_all
  end

end
