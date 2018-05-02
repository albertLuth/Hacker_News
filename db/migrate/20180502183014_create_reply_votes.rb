class CreateReplyVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :reply_votes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :reply, foreign_key: true
      t.integer :upvote
      t.integer :downvote

      t.timestamps
    end
  end
end
