class AddDateToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :date, :date
  end
end
