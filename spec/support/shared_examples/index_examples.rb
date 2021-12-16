RSpec.shared_examples "shared presence" do |attributes|
  attributes.each do |attr|
    it {should validate_presence_of(attr)}
  end
end

RSpec.shared_examples "shared enum examples" do |attr, attrs, type|
  describe "#{attr}" do
    it do
      should define_enum_for(attr).with_values(attrs)
      .backed_by_column_of_type(type)
    end
  end
end

RSpec.shared_examples "shared status failed" do |current_status, change_status, message|
  context "when #{message}" do
    let(:order){FactoryBot.create(:order, status: current_status)}
    before do
      put :update, params: {id: order.id, status: change_status}
    end

    it "should #{message} message" do
      expect(flash[:danger]).to eq message
    end
  end
end

RSpec.shared_examples "shared status success" do |current_status, change_status, status_name|
  context "when status #{status_name} change success" do
    let(:order){FactoryBot.create(:order, status: current_status)}
    before do
      put :update, params: {id: order.id, status: change_status}
    end

    it "should changed status" do
      expect(order.status).to eq "#{status_name}"
    end
  end
end

RSpec.shared_examples "shared fetch_object" do
  context "when order not found" do
    before do
      get :edit, params: {id: -1}
    end

    it "should not find to order" do
      expect(flash[:danger]).to eq "error_not_find"
    end

    it "should redirect to admin orders" do
      expect(response).to redirect_to admin_products_path
    end
  end
end
