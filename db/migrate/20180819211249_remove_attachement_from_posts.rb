class RemoveAttachementFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :attachment, :varchar
  end
end
