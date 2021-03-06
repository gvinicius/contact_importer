class Contact < ApplicationRecord
  KEY = "%\x04\x1Et\xC4\x88\x8F\x9D\xC6\xD3\xD1\x7F\x92\xF9 DQ\x14\x19\x8D\xA7\xE9\x1DZ\xD4\xDF\xE5\xB4\x8F\x9D\xC7\x15"
  IV = "\x86v\xF5\xD4\xFF\xD0\xAA\xEB\x9C\x9C\x0Ea"
  belongs_to :user
  extend AttrEncrypted

  attr_accessor :card
  attr_encrypted :credit_card, key: KEY
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

  def prepared_contact
    result = as_json.except!("encrypted_credit_card")
      result.merge({card_ref: self.credit_card.to_s[-4,self.credit_card.length], date_of_birth: Date.parse(date_of_birth).strftime("%Y %B %e")}) end

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
    if CreditCardValidations::Detector.new(card).presence
      self.credit_card = card
    end
    return unless self.encrypted_credit_card.nil?


    errors.add(:encrypted_credit_card, 'invalid')
  end
end
