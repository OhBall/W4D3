# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  has_many :cats
    
  after_initialize :ensure_session_token

  attr_reader :password
  
  def reset_session_token!
    session_token = self.class.generate_session_token
    save!
    session_token
  end
  
  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end
    
  def password=(password)
    @password = password
    # debugger
    self.password_digest = BCrypt::Password.create(password)
  end 
  
  def is_password?(password)
    password == BCrypt::Password.new(password_digest)
  end 
  
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end 
  
  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return user if user && user.is_password?(password) 
    nil 
  end 
end
