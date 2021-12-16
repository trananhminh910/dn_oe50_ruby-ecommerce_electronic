require "rails_helper"
include SessionsHelper

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    context "when logged in yet" do
      before {get :new}

      it {should respond_with(:success)}
      it {should render_template(:new)}
    end
  end

  describe "POST #create" do
    describe "when admin account" do
      let!(:is_admin) {FactoryBot.create(:user, role: 1)}

      before do
        post :create, params: {session: {email: is_admin.email, password: is_admin.password, remember_me: "1"}}
      end

      it {should set_session[:user_id].to(is_admin.id)}

      it "should redirect to Admin root_url" do
        should redirect_to(admin_root_url)
      end
    end

    describe "when customer account" do
      let!(:is_customer) {FactoryBot.create(:user, role: 0)}

      before do
        post :create, params: {session: {email: is_customer.email, password: is_customer.password, remember_me: "1"}}
      end

      it {should set_session[:user_id].to(is_customer.id)}

      it "should redirect to root_url" do
        should redirect_to(root_url)
      end
    end

    context "invalid email or password" do
      before do
        post :create, params: {session: {email: FactoryBot.create(:user).email, password: "222222"}}
      end

      it "should invalid email password message" do
        expect(flash[:danger]).to eq(I18n.t("sessions.invalid_email_password"))
      end

      it "should render login page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #destroy" do
    let!(:user) {FactoryBot.create(:user)}

    before do
      session[:user_id] = user.id
      get :destroy
    end

    context "when destroy user" do
      it "should destroy user in session" do
        expect(session[:user_id]).to eq nil
      end

      it "should redirect to root_url" do
        should redirect_to(root_url)
      end
    end
  end
end
