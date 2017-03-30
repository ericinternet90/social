class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  devise :omniauthable, omniauth_providers: [:facebook]

  has_many :identities

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  def self.find_or_create_by_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_or_initialize_by_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified

      if email_is_verified && User.exists?(email: email)
        user = User.find_by(email: email)
      elsif User.exists?(email: identity.temp_user_email)
        user = User.find_by(email: identity.temp_user_email)
      else
        user = User.new(
          # name: auth.extra.raw_info.name,
          # username: auth.info.nickname || auth.uid,
          email: email ? email : identity.temp_user_email,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    identity.set_user!(user) if identity.user != user

    user
  end


  def email_verified?
    self.email && !self.email.empty? && self.email !~ TEMP_EMAIL_REGEX
  end

end
