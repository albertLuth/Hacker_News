class User < ApplicationRecord
    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
          user.provider = auth.provider
          user.uid = Digest::SHA256.hexdigest(auth.uid)
          user.name = auth.info.name
          user.email = auth.info.email
          user.oauth_token = auth.credentials.token
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          user.save!
        end
      end
      def owns_post?(post)
        self == post.user
      end

      def upvote(post)
        votes.create(upvote: 1, post: post)
      end
      def upvoted?(post)
        votes.exists?(upvote: 1, post: post)
      end

      def remove_vote(post)
        votes.find_by(post: post).destroy
      end
      def downvote(post)
        votes.create(downvote: 1, post: post)
      end

      def downvoted?(post)
        votes.exists?(downvote: 1, post: post)
      end

      def upvote_comment(comment)
        comment_votes.create(upvote: 1, comment: comment)
      end
      def upvoted_comment?(comment)
        comment_votes.exists?(upvote: 1, comment: comment)
      end

      def remove_comment_vote(comment)
        comment_votes.find_by(comment: comment).destroy
      end
      def downvote_comment(comment)
        comment_votes.create(downvote: 1, comment: comment)
      end

      def downvoted_comment?(comment)
        comment_votes.exists?(downvote: 1, comment: comment)
      end

      def upvote_reply(reply)
        reply_votes.create(upvote: 1, reply: reply)
      end
      def upvoted_reply?(reply)
        reply_votes.exists?(upvote: 1, reply: reply)
      end

      def remove_reply_vote(reply)
        reply_votes.find_by(reply: reply).destroy
      end
      def downvote_reply(reply)
        reply_votes.create(downvote: 1, reply: reply)
      end

      def downvoted_reply?(reply)
        reply_votes.exists?(downvote: 1, reply: reply)
      end
      has_many :posts, dependent: :destroy
      has_many :votes
      has_many :comment_votes
      has_many :reply_votes
end
