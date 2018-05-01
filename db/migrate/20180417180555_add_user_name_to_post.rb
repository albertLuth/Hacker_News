class AddUserNameToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :user_name, :string
  end
end
