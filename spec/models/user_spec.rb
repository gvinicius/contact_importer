# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:some_difficult_pass) { '13o12okepokwopdasifm3tASDSAF,l@@' }
  let(:user) do
    FactoryBot.create(:user, password: some_difficult_pass)
  end

  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:username) }

  it 'is database authenticable' do
    expect(user.valid_password?(some_difficult_pass)).to be(true)
  end

  it 'does not accepts repetition in usernames' do
    new_user = user.dup

    expect(new_user).to_not be_valid
  end
end
