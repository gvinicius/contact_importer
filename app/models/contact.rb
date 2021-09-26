class Contact < ApplicationRecord
  belongs_to :user
  extend AttrEncrypted

  attr_accessor :card
  attr_encrypted :credit_card, key: 'This is a key that is 256 bits!!'
  validates :name, presence: true, format: { with: /\A[a-zA-Z,-]*\z/i, message: 'invalid'}
  validates :date_of_birth, presence: true
  validate :validate_date_of_birth
  validates :phone, presence: true
  validate :validate_phone
  validates :address, presence: true
  validates :franchise, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :validate_repeated_contact_by_user
  validate :validate_credit_card
  before_validation :add_franchise

  private

  def add_franchise
    return nil unless card.present?

    self.franchise = CreditCardValidations::Detector.new(card)&.brand&.to_s
  end

  def validate_date_of_birth
    return if (date_of_birth =~ /\A\d{4}\d{2}\d{2}$/ || date_of_birth =~ /\A\d{4}-\d{2}-\d{2}$/).presence

    errors.add(:date_of_birth, 'invalid')
  end

  def validate_phone
    return if (phone =~ /\A\(\+\d{2}\) \d{3}-\d{3}-\d{2}-\d{2}\z/ || phone =~ /\A\(\+\d{2}\) \d{3} \d{3} \d{2} \d{2}\z/).presence

    errors.add(:phone, 'invalid')
  end

  def validate_repeated_contact_by_user
    return if Contact.where(user: user, email: email).count == 0

    errors.add(:email, 'repeated')
  end

  def validate_credit_card
    return if CreditCardValidations::Detector.new(card).presence

    errors.add(:encrypted_credit_card, 'invalid')
  end
end
