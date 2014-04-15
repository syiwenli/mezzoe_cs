require 'spec_helper'

describe UsersController do

  let(:valid_params) {{user: {
                        email: "HOLLY_RAE_M3ZZ03@GMAIL.COM",
                        survey: "{1=> no}{2=> yes}{fin=> yes}"}
  }}

  describe "GET index" do
    it "assigns all events as @events" do
      get :index, {}
      assigns(:user).should be_a_new(User)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, valid_params
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, valid_params
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the index page" do
        post :create, valid_params
        response.should redirect_to root_path
        flash[:notice].should eq(I18n.t('thanks'))
      end
    end

    describe "with the same email" do
      it "redirects user to the index page with an alert message" do
        User.any_instance.stub(:prepare_user).and_return(false)
        post :create, valid_params
        response.should redirect_to root_path
        flash[:alert].should eq(I18n.t('activemodel.user.error.email.unique'))
      end
    end

    describe "with unsuccessful save" do
      it "shows 'uh oh' alert message" do
        User.any_instance.stub(:save).and_raise("error")
        post :create, {}
        response.should redirect_to root_path
        flash[:alert].should eq(I18n.t('uh_oh'))
      end
    end
  end
end
