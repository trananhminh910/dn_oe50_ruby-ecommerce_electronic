require "rails_helper"
require "support/shared_examples/index_examples.rb"

RSpec.describe Product, type: :model do
  subject {FactoryBot.create :product}

  it "is valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it {should belong_to(:category)}
    it {should have_many(:order_details).dependent(:destroy)}
    it {should have_many(:rates).dependent(:destroy)}
    it {should accept_nested_attributes_for(:category)}
    it {should have_one_attached(:image)}
  end

  describe "creating Product with valid attributes and nested Category attributes" do
    before(:each) do
     @attrs = {name: "Laptop", price: 100, discount: 100, residual: 100, description: "nice", category_attributes: {name: "Electronic", parent_id: nil}}
    end

    it "should change the number of Product by 1" do
      lambda do
        Product.create(@attrs)
      end.should change(Product, :count).by(1)
    end

    it "should change the number of Category by 1" do
      lambda do
        Product.create(@attrs)
      end.should change(Category, :count).by(1)
    end
  end

  describe "validations" do
    it "is valid attributes" do
      should be_valid
    end

    it_behaves_like "shared presence", %i(name price discount residual description)

    context "name" do
      it {expect(subject.name).to be_kind_of String }
      it {should validate_length_of(:name).is_at_most(Settings.product.max_length_name)}
    end

    context "price" do
      it {expect(subject.price).to be_kind_of Float }
      it {expect(subject.price).to be >= 0}
    end

    context "discount" do
      it {expect(subject.discount).to be_kind_of Integer }
      it {expect(subject.discount).to be >= Settings.product.min_discount}
      it {expect(subject.discount).to be <= Settings.product.max_discount}
    end

    context "residual" do
      it {expect(subject.residual).to be_kind_of Integer }
      it {expect(subject.residual).to be <= Settings.product.max_residual}
    end
  end

  describe "scopes" do
    describe ".product_order" do
      it "should valid order attributes" do
        product_1 = FactoryBot.create(:product, price: 1)
        product_2 = FactoryBot.create(:product, price: 5)
        product_order = Product.product_order :price
        expect(product_order).to eq [product_1, product_2]
      end
    end

    describe ".search" do
      let(:product_1) {FactoryBot.create(:product, name: "abcd")}
      let(:product_2) {FactoryBot.create(:product, name: "dbca")}
      let(:product_3) {FactoryBot.create(:product, name: "bbbb", description: "nice ah")}
      let(:product_4) {FactoryBot.create(:product, name: "dvebca", description: "good")}

      it "should find to products" do
        keyword = "a"
        product_order = Product.searchs keyword
        expect(product_order).to eq [product_1, product_2, product_3, product_4]
      end

      it "should not find to product" do
        keyword = "minh"
        product_order = Product.searchs keyword
        expect(product_order).to eq []
      end
    end
  end

  describe "methods" do
    let(:product) {FactoryBot.create(:product, residual: 1)}

    describe "#check_residual_quantity?" do
      it "should valid quantity params residual quantity" do
        quantity_params = 1
        expect(product.check_residual_quantity? quantity_params).to eq true
      end

      it "should invalid quantity params residual quantity" do
        quantity_params = 2
        expect(product.check_residual_quantity? quantity_params).not_to eq true
      end
    end
  end
end
