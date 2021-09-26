require 'csv'

class Import < ApplicationRecord
  enum status: %w(on_hold processing failed terminated)

  has_one_attached :sheet
  validate :acceptable_sheet

  belongs_to :user

  def run
    update(status: :processing)
    errors = []
    total = 0

    CSV.foreach(ActiveStorage::Blob.service.path_for(sheet.key), headers: true) do |row|
      total = total +1
      data = row.to_hash

      card = data.delete('credit_card')
      contact = Contact.new(data)
      contact.card = card
      contact.user = self.user

      contact.save!
    rescue Exception => error
      errors += ["#{total}: #{error.to_s}"]
    end

    if errors.empty?
      update(status: :terminated, total: total)
    else
      update(status: :failed, total: total, report: errors.join('\n'))
    end
  end

  private

  def acceptable_sheet
    return unless sheet.attached?

    acceptable_types = ['text/csv']
    unless acceptable_types.include?(sheet.content_type)
      errors.add(:sheet, 'must be a CSV')
    end
  end
end
