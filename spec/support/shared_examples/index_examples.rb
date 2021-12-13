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
