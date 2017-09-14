class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  validates :session_token, presence: true

  has_many :posts

  attr_reader :password

  after_initialize :ensure_session_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)

    self.save
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    user && user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!

    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

end