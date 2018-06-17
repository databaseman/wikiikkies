class Post < ApplicationRecord
  belongs_to :user

  has_many   :collaborators, dependent: :destroy
  has_many   :user_collaborators, through: :collaborators, source: :user

  #default_scope { order(updated_at: :desc) }
  #default_scope { order(title: :desc) }

  #validates :title, presence: true, length: { maximum: 70 }
  validates :title, presence: true
end
