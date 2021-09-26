require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) do
    FactoryBot.build(:contact)
  end

  context 'when creating a contact' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:date_of_birth) }
    it { is_expected.to respond_to(:phone) }
    it { is_expected.to respond_to(:address) }
    it { is_expected.to respond_to(:credit_card) }
    it { is_expected.to respond_to(:franchise) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:user) }

    it 'points a validation for the default set of valid attributes' do
      contact.save!

      expect(contact.errors).to be_empty
    end

    it 'rejects an invalid name' do
      contact.name = 'a. '
      contact.valid?

      expect(contact.errors.details[:name]).to_not be_empty
    end

    it 'rejects an invalid date_of_birth' do
      contact.date_of_birth = '22aaaa'
      contact.valid?

      expect(contact.errors.details[:date_of_birth]).to_not be_empty
    end

    it 'rejects an invalid phone' do
      contact.phone = '+00 000 000 00 00'
      contact.valid?

      expect(contact.errors.details[:phone]).to_not be_empty
    end

    it 'rejects an invalid address' do
      contact.address = ''
      contact.valid?

      expect(contact.errors.details[:address]).to_not be_empty
    end

    it 'rejects an invalid email' do
      contact.email = 'a...@....'
      contact.valid?

      expect(contact.errors.details[:email]).to_not be_empty
    end

    describe '#validate_repeated_contact_by_user' do
      before do
        contact.dup.save
      end

      let(:different_user) { FactoryBot.create(:user, username: 'another_person') }

      it 'allows to save an existing email for a different user' do
        contact.user = different_user
        contact.valid?

        expect(contact.errors.details[:email]).to be_empty
      end

      it 'does not allow to save an existing email for a different user' do
        contact.valid?

        expect(contact.errors.details[:email]).to_not be_empty
      end

      it 'allows to save an existing email for a different user' do
        contact.user = different_user
        contact.valid?

        expect(contact.errors.details[:email]).to be_empty
      end
    end

    describe '#validate_credit_card' do
      before do
        contact.dup.save
      end

      let(:different_user) { FactoryBot.create(:user, username: 'another_person') }

      it 'allows to save an existing email for a different user' do
        contact.user = different_user
        contact.valid?

        expect(contact.errors.details[:email]).to be_empty
      end

      it 'does not allow to save an existing email for a different user' do
        contact.valid?

        expect(contact.errors.details[:email]).to_not be_empty
      end

      it 'allows to save an existing email for a different user' do
        contact.user = different_user
        contact.valid?

        expect(contact.errors.details[:email]).to be_empty
      end
    end
  end

  describe '#add_franchise' do
    it 'sets a correct franchise for a given credit_card' do
      expect{ contact.send(:add_franchise) }.to change { contact.franchise }.from('').to('amex')
    end

    it 'does not set a correct franchise given a wrong credit_card' do
      contact.credit_card = nil

      expect{ contact.send(:add_franchise) }.to_not change { contact.franchise }
    end
  end
end
