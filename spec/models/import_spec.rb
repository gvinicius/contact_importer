require 'rails_helper'

RSpec.describe Import, type: :model do
  let(:import) do
    FactoryBot.create(:import)
  end

  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:report) }
  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:sheet) }

  describe '#run' do
    it 'imports just one correct contact' do
      expect{ import.run }.to change { Contact.count }.by(1)
    end
  end
end
