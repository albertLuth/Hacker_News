class AddPointsToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :points, :integer
  end
end
