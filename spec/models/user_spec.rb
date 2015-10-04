require 'rails_helper'

RSpec.describe User do
  context 'associations' do
    it { should have_many(:places) }
    it { should have_many(:identities) }
    it { should have_one(:place_importer).class_name('Place::Importer') }
  end

  describe '.from_omniauth' do
    context "the user doesn't exist" do
      let(:auth) { stub_auth(uid: ENV['FOURSQUARE_USER_ID']) }

      before do
        clear_enqueued_jobs
      end

      it 'creates a new user' do
        user = User.from_omniauth(auth)

        expect(user).to be_valid
      end

      it 'creates a new main identity attached to the user' do
        expect { User.from_omniauth(auth) }.to change { Identity.count }.by(1)
      end

      it "imports the user's places in a job" do
        User.from_omniauth(auth)

        expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
      end
    end

    context 'the user exists' do
      let!(:auth) { stub_auth(uid: ENV['FOURSQUARE_USER_ID']) }
      let!(:existing_user) { User.from_omniauth(auth) }

      it 'returns the existing user' do
        user = User.from_omniauth(auth)

        expect(user).to eq(existing_user)
      end

      it "doesn't create a new user" do
        expect { User.from_omniauth(auth) }.to_not change { User.count }
      end
    end
  end

  describe '.create_from_omniauth' do
    context 'with an already existing uid' do
      let(:auth) { stub_auth(uid: ENV['FOURSQUARE_USER_ID']) }

      before do
        User.create_from_omniauth(auth)
      end

      it 'returns nil' do
        user = User.create_from_omniauth(auth)

        expect(user).to be_nil
      end
    end

    context 'with an authorized uid' do
      let(:auth) { stub_auth(uid: ENV['FOURSQUARE_USER_ID']) }

      it 'creates a new user' do
        expect { User.create_from_omniauth(auth) }.
          to change { User.count }.by(1)
      end

    end
  end

  describe '#main_identity' do
    context 'when there is a primary identity' do
      it 'returns the primary identity' do
        auth = stub_auth(uid: ENV['FOURSQUARE_USER_ID'])
        user = User.create_from_omniauth(auth)
        identity = Identity.where(uid: ENV['FOURSQUARE_USER_ID']).first

        expect(user.main_identity).to eq(identity)
      end
    end

    context 'when there is not a primary identity' do
      it 'returns nil' do
        user = build_stubbed(:user)
        expect(user.main_identity).to be_nil
      end
    end
  end

  describe '#import_places' do
    subject { build_stubbed(:user) }

    context 'initial import' do
      around do |example|
        VCR.use_cassette('place_importer.first_import') do
          example.run
        end
      end

      it 'imports all of the user places', slow: true do
        expect { subject.import_places }.to change { Place.count }.by(144)
      end
    end
  end

  def stub_auth(options)
    stub_oauth(uid: options[:uid], token: Faker::Internet.password)
  end

  def authorized_uids
    ENV.fetch('FOURSQUARE_USER_ID').split(',')
  end
end
