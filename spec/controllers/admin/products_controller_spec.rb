require "rails_helper"
include SessionsHelper
require "support/shared_examples/index_examples"

RSpec.describe Admin::ProductsController, type: :controller do
  let(:product){FactoryBot.create(:product)}
  let(:admin){FactoryBot.create(:user, role: :admin)}

  describe "when valid routing" do
    it{should route(:get, "/admin/products").to(action: :index)}
    it{should route(:get, "/admin/products/new").to(action: :new)}
    it{should route(:post, "/admin/products").to(action: :create)}
    it{should route(:get, "/admin/products/1/edit").to(action: :edit, id: 1)}
    it{should route(:put, "/admin/products/1").to(action: :update, id: 1)}
    it{should route(:get, "/admin/products/1").to(action: :show, id: 1)}
    it{should route(:delete, "/admin/products/1").to(action: :destroy, id: 1)}
  end

  describe "GET #index" do
    before {product}

    it "should invalid login" do
      get :index
      expect(response).to redirect_to login_path
    end

    context "when signed in as admin" do
      before do
        log_in admin
        get :index
      end

      it "should assign products" do
        expect(assigns(:products)).to eq([product])
      end
      it{should render_template(:index)}
    end
  end

  describe "GET #edit" do
    before {log_in admin}
    before {product}

    it_behaves_like "shared fetch_object"

    context "when find to valid order" do
      before do
        get :edit, params: {id: product.id}
      end

      it "should show edit product" do
        expect(assigns(:product)).to eq product
      end

      it{should render_template(:edit)}
    end
  end

  describe "PATCH #update" do
    before {log_in admin}
    before {product}

    it_behaves_like "shared fetch_object"
  end

  describe "DELETE #destroy" do
    before {log_in admin}
    before {product}

    it_behaves_like "shared fetch_object"

    context "when destroy product success" do
      it "should redirect after destroy" do
        delete :destroy, params: {id: product.id}
        expect(response).to redirect_to admin_products_url
      end
    end
  end
end
