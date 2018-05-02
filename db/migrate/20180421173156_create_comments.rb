class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, foreign_key: {on_delete: :cascade}
      t.references :post, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
