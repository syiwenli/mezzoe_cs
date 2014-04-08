class User < ActiveRecord::Base
  validates :email, presence: {message: t('activemodel.user.error.required')}
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Please enter a valid email address"}
  validates :email, uniqueness: true
  validates :survey, presence: true


end
