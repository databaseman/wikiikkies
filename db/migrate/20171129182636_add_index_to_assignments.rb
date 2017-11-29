class AddIndexToAssignments < ActiveRecord::Migration[5.0]
  def change
    remove_index :assignments, column: :user_id
    remove_index :assignments, column: :role_id
    add_index :assignments, [:user_id, :role_id], unique: true
  end
end
