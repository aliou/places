require 'rails_helper'

RSpec.describe Identity, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:oauth_token) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe '.create_from_auth' do
    context 'when an Identity with the same provider and uid already exists' do
      let(:auth) { stub_auth }

      it 'returns nil' do
        identity = Identity.create_from_auth(auth)
        expect(Identity.create_from_auth(auth)).to eq(nil)
      end
    end

    context 'when there are no identitcal Identity' do
      let(:auth) { stub_auth }

      it 'creates a new Identity' do
        expect{ Identity.create_from_auth(auth) }.
          to change { Identity.count }.by(1)
      end
    end
  end

  describe '.from_auth' do
    context 'when the Identity already exists' do
      let(:auth) { stub_auth }

      it 'returns the existing identity' do
        identity = Identity.create_from_auth(auth)
        expect(Identity.from_auth(auth)).to eq(identity)
      end
    end

    context "when the Identity doesn't exists" do
      let(:auth) { stub_auth }

      it 'creates a new Identity' do
        expect{ Identity.from_auth(auth) }.
          to change { Identity.count }.by(1)
      end
    end
  end

  def stub_auth
    stub_oauth(provider: Identity::PROVIDERS.sample,
               uid: Faker::Internet.password,
               token: Faker::Internet.password)
  end
end
