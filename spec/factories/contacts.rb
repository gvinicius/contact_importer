FactoryBot.define do
  factory :contact do
    name { Faker::name.to_s + '-' }
    date_of_birth { '20010110' }
    phone { '(+00) 000-000-00-00' }
    address { 'My Adress' }
    card { '371449635398431' }
    franchise { '' }
    email { 'aaa@aaa.com' }
    user { create(:user) }
  end
end
