class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.text :content
      t.references :user, foreign_key: {on_delete: :cascade}
      t.references :comment, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
