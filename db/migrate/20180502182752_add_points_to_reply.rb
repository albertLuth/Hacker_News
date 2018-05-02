class AddPointsToReply < ActiveRecord::Migration[5.1]
  def change
    add_column :replies, :points, :integer
  end
end
