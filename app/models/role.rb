class Role < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments

  validates :name, presence: true, uniqueness: true
  before_destroy :convert_posts, :destroy_assignments  # remove dependents first. Have to do this with has_many through

  def destroy_assignments
    self.assignments.destroy_all
  end

  def convert_posts
    users=User.all.roles.where(name: self.name)
  end
end
