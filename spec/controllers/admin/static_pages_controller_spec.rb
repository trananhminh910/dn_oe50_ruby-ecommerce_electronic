require "rails_helper"

RSpec.describe Admin::StaticPagesController, type: :controller do
  let(:admin){FactoryBot.create(:user, role: :admin)}

  describe "when valid routing" do
    it{should route(:get, "/admin").to(action: :index)}
  end

  describe "GET #index" do
    before {get :index}

    context "when invalid login" do
      it "should invalid login" do
        expect(response).to redirect_to signin_path
      end

      it "should invalid login message" do
        expect(flash[:danger]).to eq I18n.t("sessions.login_please")
      end
    end

    context "when invalid admin" do
      let(:admin){FactoryBot.create(:user, role: :admin)}
      before do
        sign_in admin
        get :index
      end

      it "should invalid render template admin" do
        should render_template(:index)
      end
    end
  end
end
