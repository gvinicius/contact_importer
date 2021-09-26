include ActionDispatch::TestProcess

FactoryBot.define do
  factory :import do
    status { 1 }
    total { 2 }
    report { "" }
    user { create(:user) }

    after(:build) do |user|
      user.sheet.attach(io: File.open("#{Rails.root}/spec/fixtures/sheet.csv"), filename: 'sheet.csv', content_type: 'text/csv')
    end
  end
end
