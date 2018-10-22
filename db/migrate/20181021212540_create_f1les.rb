class CreateF1les < ActiveRecord::Migration[5.1]
  def change
    create_table :f1les do |t|
      t.string :name
      t.string :attachment
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
