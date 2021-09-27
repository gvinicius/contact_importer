require 'csv'

class Import < ApplicationRecord
  enum status: %w(on_hold processing failed terminated)

  has_one_attached :sheet

  validates :sheet, presence: true, blob: { content_type: ['text/csv'], size_range: 1..5.megabytes }

  belongs_to :user

  def run
    update(status: :processing)
    errors = []
    total = 0
    errored = 0

    CSV.foreach(ActiveStorage::Blob.service.path_for(sheet.key), headers: true) do |row|
      total = total + 1
      data = row.to_hash

      card = data.delete('credit_card')
      contact = Contact.new(data)
      contact.card = card
      contact.user = self.user

      contact.save!
    rescue Exception => error
      errored = errored + 1
      errors += ["#{total}: #{error.to_s}"]
    end

    if errors.empty?
      update(status: :terminated, total: total)
    else
      errors = ["Errors total: #{errored.to_s}"] + errors
      update(status: :failed, total: total, report: errors.join('\n'))
    end
  end
end
