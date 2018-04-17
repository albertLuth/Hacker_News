class AddUserUidToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :user_uid, :string
  end
end
