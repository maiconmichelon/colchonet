#encoding: utf-8
class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  has_many :reviews, dependent: :destroy
  has_many :rooms, dependent: :destroy

  validates_presence_of :full_name, :location, :email
  validates_length_of :bio, minimum: 30, allow_blanck: false
  validates_uniqueness_of :email
  validates_format_of :email, with: EMAIL_REGEXP

  has_secure_password

  scope :most_recent, -> {order('created_at DESC')}
  scope :from_sampa, -> {where(location: 'São Paulo')}
  scope :from, ->(location) {where(location: location)}
  scope :confirmed, -> {where.not(confirmed_at: nil) }

  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?

    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  def confirmed?
    confirmed_at.present?
  end

  def self.authenticate(email, password)
    user = confirmed.find_by(email: email).try(:authenticate, password)
  end

end
