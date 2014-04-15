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

  describe "#prepare_user" do
    describe "when the user signs up for the first time" do
      context "with valid params" do
        it "returns true and sanitizes params" do
          @user = User.new(valid_params[:user])
          expect(@user.prepare_user(valid_params[:user][:survey])).to eq(true)
          expect(@user.email).to eq(valid_attributes[:email])
          expect(@user.survey).to eq(valid_attributes[:survey])
        end
      end

      context "with invalid survey param" do
        it "returns true and survey param is nil" do
          invalid_param = {survey: "#%*)00!%00@#kinvalid"}
          @user = User.new(valid_params[:user])
          expect(@user.prepare_user(invalid_param)).to eq(true)
          expect(@user.survey).to be_nil
        end

      end
    end
  end

  describe "validate user" do
    context "with invalid email" do
      it "shows email format error message" do
        @user = User.new({email: "#%$%$&^%#&^%#@%00n.com"})
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to include(I18n.t('activemodel.user.error.email.format'))
        expect(@user.errors[:email]).not_to include(I18n.t('activemodel.user.error.email.required'))
      end
    end

    context "with missing email" do
      it "shows email missing error message" do
        @user = User.new({email: ""})
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to include(I18n.t('activemodel.user.error.email.required'))
      end
    end

    context "with the same email in db" do
      it "shows email unique error message" do
        @user_a = User.new({email: "hi@mezzoe.com"})
        @user_a.save
        @user = User.new({email: "hi@mezzoe.com"})
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to include(I18n.t('activemodel.user.error.email.unique'))
      end
    end
  end
end
