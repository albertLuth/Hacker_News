class AddPointsAndHotscoreToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :points, :integer ,default: 1
    add_column :posts, :hot_score, :float ,default: 0
  end
end
