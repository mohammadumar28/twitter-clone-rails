class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_writer :login
  validate :validate_username

  has_many :active_relationships, class_name: "Follower", foreign_key: "following_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Follower", foreign_key: "follower_id", dependent: :destroy

  has_many :followings, through: :active_relationships, source: :following
  has_many :followers, through: :passive_relationships, source: :follower

  # Follow helpers
  def follow(other)
    active_relationships.create(follower_id: other.id)
  end

  def unfollow(other)
    active_relationships.find_by(follower_id: other.id).destroy
  end

  def following?(other)
    following.include?(other.id)
  end

  # Devise helper methods
  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
end