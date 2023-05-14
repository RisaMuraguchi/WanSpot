class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :caption
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :user_id
      t.timestamps
    end
  end
end

