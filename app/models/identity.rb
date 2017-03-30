# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_identities_on_user_id  (user_id)
#

class Identity < ApplicationRecord
  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_or_initialize_by_oauth(auth)
    find_or_initialize_by(uid: auth.uid, provider: auth.provider)
  end

  def set_user!(new_user)
    self.user = new_user
    self.save!
  end

  def temp_user_email
    "#{ User::TEMP_EMAIL_PREFIX }-#{ self.uid }-#{ self.provider }.com"
  end

end
