require "rails_helper"
include SessionsHelper
require "support/shared_examples/index_examples"

RSpec.describe Admin::OrdersController, type: :controller do
  let(:order){FactoryBot.create(:order)}
  let(:admin){FactoryBot.create(:user, role: :admin)}

  describe "when valid routing" do
    it{should route(:get, "/admin/orders").to(action: :index)}
    it{should route(:get, "/admin/orders/1/edit").to(action: :edit, id: 1)}
    it{should route(:put, "/admin/orders/1").to(action: :update, id: 1)}
  end

  describe "GET #index" do
    before{order}

    it "should invalid login" do
      get :index
      expect(response).to redirect_to login_path
    end

    context "when signed in as admin" do
      before do
        log_in admin
        get :index
      end

      it "should assign orders" do
        expect(assigns(:orders)).to eq([order])
      end
      it{should render_template(:index)}
    end
  end

  describe "GET #edit" do
    before {log_in admin}
    before{order}

    context "when order not found" do
      before do
        get :edit, params: {id: -1}
      end

      it "should not find to order" do
        expect(flash[:danger]).to eq I18n.t("sessions.error_not_find")
      end

      it "should redirect to admin orders" do
        expect(response).to redirect_to admin_orders_path
      end
    end

    context "when find to valid order" do
      before do
        get :edit, params: {id: order.id}
      end

      it "should show edit order" do
        expect(assigns(:order)).to eq order
      end

      it{should render_template(:edit)}
    end
  end

  describe "PATCH #update" do
    before {log_in admin}
    before{order}

    context "when order not found" do
      before do
        get :edit, params: {id: -1}
      end

      it "should not find to order" do
        expect(flash[:danger]).to eq I18n.t("sessions.error_not_find")
      end

      it "should redirect to admin orders" do
        expect(response).to redirect_to admin_orders_path
      end
    end

    it_behaves_like "shared status success", 0, 1, "pending"
    it_behaves_like "shared status success", 0, 3, "pending"
    it_behaves_like "shared status success", 1, 3, "accept"

    it_behaves_like "shared status failed", 3, 2, I18n.t("orders.cancel_failed")
    it_behaves_like "shared status failed", 3, 1, I18n.t("orders.accept_failed")
    it_behaves_like "shared status failed", 3, 0, I18n.t("orders.pending_failed")

    it_behaves_like "shared status failed", 1, 2, I18n.t("orders.cancel_failed")
    it_behaves_like "shared status failed", 1, 0, I18n.t("orders.pending_failed")

    it_behaves_like "shared status failed", 0, 0, I18n.t("orders.pending_failed")
    it_behaves_like "shared status failed", 0, 2, I18n.t("orders.cancel_failed")
  end
end

