class User < ApplicationRecord
    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
          user.provider = auth.provider
          user.uid = auth.uid
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
      has_many :posts, dependent: :destroy
      has_many :votes
end
