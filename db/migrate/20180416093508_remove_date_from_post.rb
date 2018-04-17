class RemoveDateFromPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :date, :date
  end
end
