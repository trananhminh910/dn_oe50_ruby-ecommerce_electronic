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
