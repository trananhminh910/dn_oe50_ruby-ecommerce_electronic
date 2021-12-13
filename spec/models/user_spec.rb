require "rails_helper"
require "support/shared_examples/index_examples.rb"

RSpec.describe User, type: :model do
  subject {FactoryBot.create :user}

  it "is valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it {should have_many(:addresses).dependent(:destroy)}
    it {should have_many(:rates).dependent(:destroy)}
    it {should have_many(:orders).dependent(:destroy)}
  end

  describe "is valid enums" do
    it_behaves_like "shared enum examples", :role, User.roles, :integer
    it_behaves_like "shared enum examples", :gender, User.genders, :boolean
    it_behaves_like "shared enum examples", :is_active, User.is_actives, :boolean
  end

  describe "validations" do
    it "is valid attributes" do
      should be_valid
    end

    it_behaves_like "shared presence", %i(email name gender)

    context "email" do
      it {should validate_uniqueness_of(:email).ignoring_case_sensitivity}
      it {should validate_length_of(:email).is_at_most(Settings.length.max_length_email)}

      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
         foo@bar_baz.com foo@bar+baz.com]
         addresses.each do |invalid_address|
          subject.email = invalid_address
          expect(subject).not_to be_valid
        end
      end

      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          subject.email = valid_address
          expect(subject).to be_valid
        end
      end
    end

    context "name" do
      it {should validate_length_of(:name).is_at_least(Settings.length.min_length_username)}
      it {should validate_length_of(:name).is_at_most(Settings.length.max_length_username)}
    end

    context "password" do
      it {should validate_presence_of(:password).allow_nil}
      it {should validate_length_of(:password).is_at_least(Settings.length.min_length_password)}
      it {should validate_confirmation_of(:password)}
    end

    context "has secure password" do
      it {should have_secure_password}
    end
  end

  describe ".new_token" do
    let(:new_token) {User.new_token}

    it "should return a string" do
      expect(new_token).to be_kind_of String
    end

    it "should return invalid length" do
      expect(new_token.length).to eq(22)
    end
  end

  describe ".digest" do
    let(:digest) {User.digest("111111")}

    it "should present" do
      expect(digest).not_to be nil
    end

    it "should return a string" do
      expect(digest).to be_kind_of String
    end
  end

  describe "#remember" do
    let(:remember_token) {User.digest(User.new_token)}

    it "should present" do
      expect(remember_token).not_to be nil
    end
  end
end
