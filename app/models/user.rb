class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6, maximum: 30 }, format: { with: /\A[a-z\d]+\z/i }, confirmation: true, on: :create
  validates :password, presence: true, length: { minimum: 6, maximum: 30 }, format: { with: /\A[a-z\d]+\z/i }, confirmation: true, on: :update, if: :edit_password_path?
  validates :password_confirmation, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :update, if: :edit_password_path?
  validates :description, length: { maximum: 150 }

  has_one_attached :image, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  has_many :reposts, dependent: :destroy
  has_many :reposted_posts, through: :reposts, source: :post

  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user, dependent: :destroy

  def self.guest
    find_or_create_by!(email: 'guest@guest.com') do |user|
      user.password = SecureRandom.alphanumeric
      user.password_confirmation = user.password
      user.name = "ゲストくんさん"
    end
  end

  def postcount
    Post.where(user_id: id).count
  end

  def followings_with_userself
    User.where(id: self.followings.pluck(:id)).or(User.where(id: self.id))
  end

  def posts_with_reposts
    relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND reposts.user_id = #{self.id}")
                   .select("posts.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name")
    relation.where(user_id: self.id)
            .or(relation.where("reposts.user_id = ?", self.id))
            .with_attached_images
            .preload(:user, :review, :comments, :likes, :reposts)
            .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END DESC"))
  end

  def followings_posts_with_reposts
    # relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND (reposts.user_id = #{self.id} OR reposts.user_id IN (SELECT follow_id FROM relationships WHERE user_id = #{self.id})) LEFT OUTER JOIN reviews ON posts.id = reviews.post_id")
    relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND (reposts.user_id = #{self.id} OR reposts.user_id IN (SELECT follow_id FROM relationships WHERE user_id = #{self.id})) LEFT OUTER JOIN reviews ON posts.id = reviews.post_id")
                   .select("posts.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name, reviews.rate AS reviews_rate")
    # relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND (reposts.user_id = #{self.id} OR reposts.user_id IN (SELECT follow_id FROM relationships WHERE user_id = #{self.id}))")
    #                .select("posts.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name")
    relation.where(user_id: self.followings_with_userself.pluck(:id))
            .or(relation.where(id: Repost.where(user_id: self.followings_with_userself.pluck(:id)).distinct.pluck(:post_id)))
            .where("NOT EXISTS(SELECT 1 FROM reposts sub WHERE reposts.post_id = sub.post_id AND reposts.created_at < sub.created_at)")
            .with_attached_images
            .preload(:user, :review, :comments, :likes, :reposts)
            .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END DESC"))

# relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND (reposts.user_id = #{user.id} OR reposts.user_id IN (SELECT follow_id FROM relationships WHERE user_id = #{user.id})) LEFT OUTER JOIN reviews ON posts.id = reviews.post_id").select("posts.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name, reviews.rate AS reviews_rate")
# relation.where(user_id: user.followings_with_userself.pluck(:id)).or(relation.where(id: Repost.where(user_id: user.followings_with_userself.pluck(:id)).distinct.pluck(:post_id))).where("NOT EXISTS(SELECT 1 FROM reposts sub WHERE reposts.post_id = sub.post_id AND reposts.created_at < sub.created_at)").with_attached_images.preload(:user, :review, :comments, :likes, :reposts).order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END DESC"))
  end

  def reposted?(post_id)
    self.reposts.where(post_id: post_id).exists?
  end

  def liked?(post_id)
    self.likes.where(post_id: post_id).exists?
  end

  def follow(other_user)
    if self != other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def edit_password_path?
    # binding.pry
    # path = Rails.application.routes.recognize_path(request.referer)
    Thread.current[:request].fullpath.include?("/users/password")
  end

end