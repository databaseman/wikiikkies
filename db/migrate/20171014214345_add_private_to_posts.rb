class AddPrivateToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :private, :boolean, default: false
  end
end
