require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { User.create(email: 'user@test.com', password: 'password') }

  describe "associations" do
    it { should have_many(:identities) }
  end


  describe "find_or_create_by_oauth" do
    auth_params = { provider: 'provider', uid: 'uid'  }
    auth_struct = OpenStruct.new(auth_params.merge(info: OpenStruct.new,
                                                   extra: OpenStruct.new(raw_info: OpenStruct.new)))

    verified_auth_struct = OpenStruct.new(auth_params
                                            .merge(info: OpenStruct.new(email: 'user@test.com',
                                                                        verified: 'true'),
                                                   extra: OpenStruct.new(raw_info: OpenStruct.new)))

    context "User exists" do
      context "Identity exists" do
        context "User has a temp email" do
          it "Returns the existing user for the existing identity" do
            user = User.create!(email: "change@me-uid-provider.com", password: 'password')
            identity = Identity.create!(auth_params.merge(user: user))
            expect(User.find_or_create_by_oauth(auth_struct)).to eq(user)
          end
        end
        context "User doesn't have a temp email" do
          it "Returns the existing user for the existing identity" do
            user = User.create!(email: "email123@example.com", password: 'password')
            identity = Identity.create!(auth_params.merge(user: user))
            expect(User.find_or_create_by_oauth(auth_struct)).to eq(user)
          end
        end
      end

      context "Identity doesn't exist" do
        context "User has the temp email for the identity" do
          it "Returns the existing user and creates an identity for it" do
            user = User.create!(email: "change@me-uid-provider.com", password: 'password')
            expect(User.find_or_create_by_oauth(auth_struct)).to eq(user)
            expect(Identity.count).to eq(1)
            expect(Identity.first).to eq(user.identities.first)
          end
        end
      end
    end

    context "User doesn't exist" do
      context "auth email is not verified" do
        it "creates an identity and a new user with a temp email" do
          new_user = User.find_or_create_by_oauth(auth_struct)
          expect(new_user.class).to eq(User)
          expect(new_user.persisted?).to be_truthy
          expect(new_user.email_verified?).to be_falsy
          expect(Identity.count).to eq(1)
          expect(Identity.first).to eq(new_user.identities.first)
        end
      end
      context "auth email is verified" do
        it "creates an identity and a new user with a the verified email" do
          new_user = User.find_or_create_by_oauth(verified_auth_struct)
          expect(new_user.class).to eq(User)
          expect(new_user.persisted?).to be_truthy
          expect(new_user.email_verified?).to be_truthy
          expect(Identity.count).to eq(1)
          expect(Identity.first).to eq(new_user.identities.first)
        end
      end
    end

  end

end
