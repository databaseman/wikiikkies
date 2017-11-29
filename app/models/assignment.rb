class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :role

  enum role_id: [ :premium, :admin ]
end
