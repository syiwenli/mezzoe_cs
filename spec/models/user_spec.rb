require 'spec_helper'

describe User do

  let(:valid_attributes) {
    {
      email: 'h0lly_ra3@mezzoe.com',
      survey: { "1"=> "no",
                "2"=> "yes",
                "fin"=> "yes"}
  }}

  let(:valid_params) {
    {user: {
      email: "H0lly_RA3@mezzoe.com",
      survey: "{1=> no}{2=> yes}{fin=> yes}"}
  }}

  let(:user) {User.new(valid_params[:user])}

  describe "#prepare_user" do
    describe "when the user signs up for the first time" do
      context "with valid params" do
        it "returns true and sanitizes params" do
          expect(user.prepare_user(valid_params[:user][:survey])).to eq(true)
          expect(user.email).to eq(valid_attributes[:email])
          expect(user.survey).to eq(valid_attributes[:survey])
        end
      end

      context "with invalid survey param" do
        it "returns true and survey param is nil" do
          invalid_param = {survey: "#%*)00!%00@#kinvalid"}
          expect(user.prepare_user(invalid_param)).to eq(true)
          expect(user.survey).to be_nil
        end
      end
    end

    describe "when the user signed up previously" do
      it "returns false" do
        user.prepare_user(valid_params[:user][:survey])
        user.save
        user_ii = User.new(valid_params[:user])
        expect(user_ii.prepare_user(valid_params[:user][:survey])).to eq(false)
      end
    end
  end

  describe "#data_to_hash" do
    let(:valid_input) {"{1=> no}{2=> yes}{fin=> yes}"}
    let(:invalid_string_input) {"%00}"}
    let(:invalid_input) {nil}
    let(:valid_output) {{ "1"=> "no",
                          "2"=> "yes",
                          "fin"=> "yes"}}
    context "when the survey param is a valid string" do
      it "rearranges the input to a hash" do
        expect(user.data_to_hash(valid_input)).to eq(valid_output)
      end
    end

    context "when the survey param is an invalid string" do
      it "returns nil" do
        expect(user.data_to_hash(invalid_string_input)).to eq(nil)
      end
    end

    context "when the survey param is not a string" do
      it "returns nil" do
        expect(user.data_to_hash(invalid_input)).to eq(nil)
      end
    end
  end

  describe "validate user" do
    context "with invalid email" do
      it "shows email format error message" do
        user = User.new({email: "#%$%$&^%#&^%#@%00n.com"})
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include(I18n.t('activemodel.user.error.email.format'))
        expect(user.errors[:email]).not_to include(I18n.t('activemodel.user.error.email.required'))
      end
    end

    context "with missing email" do
      it "shows email missing error message" do
        user = User.new({email: ""})
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include(I18n.t('activemodel.user.error.email.required'))
      end
    end

    context "with the same email in db" do
      it "shows email unique error message" do
        user_a = User.new({email: "hi@mezzoe.com"})
        user_a.save
        user = User.new({email: "hi@mezzoe.com"})
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include(I18n.t('activemodel.user.error.email.unique'))
      end
    end
  end
end
