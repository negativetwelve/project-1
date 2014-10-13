class User < ActiveRecord::Base
  # YOUR CODE HERE
  has_secure_password
  # END
  has_many :posts, dependent: :destroy


  before_save { self.email = email.downcase }
  before_create :create_remember_token

  class << self
    def new_remember_token
      SecureRandom.urlsafe_base64
    end

    def digest(token)
      Digest::SHA1.hexdigest(token.to_s)
    end
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end

end
