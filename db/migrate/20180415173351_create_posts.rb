class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :url
      t.text :text
      t.integer :points

      t.timestamps
    end
  end
end
