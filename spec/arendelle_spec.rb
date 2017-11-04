require "spec_helper"

RSpec.describe Arendelle do
  describe "#initialize" do
    it "sets instance variables and adds accessors from the keyword values" do
      obj = Arendelle.new(name: "First Name")
      expect(obj.name).to eq "First Name"
    end
  end

  describe "#[]=" do
    context "when the value has already been set" do
      it "should raise a FrozenVariableError" do
        obj = Arendelle.new(name: "First Name")
        expect{obj["name"] = "New Name"}.to raise_error(FrozenVariableError)
      end
    end

    context "when the value starts with a number" do
      it "should be able to see the value by preceding the number with a _" do
        obj = Arendelle.new
        obj["1_test"] = "Test Value"
        expect(obj._1_test).to eq "Test Value"
      end

      it "should be not able to access the value directly" do
        obj = Arendelle.new
        obj["1_test"] = "Test Value"
        expect{obj.send("1_test")}.to raise_error(NoMethodError)
      end
    end

    context "when the value has not been set" do
      it "should set the value as expected" do
        obj = Arendelle.new(name: "First Name")
        obj["new_setting"] = "New Value"
        expect(obj.new_setting).to eq "New Value"
      end
    end
  end

  describe "#to_h" do
    it "should convert itself to a hash-like structure" do
      obj = Arendelle.new(name: "First Name", other: "Sure")
      data = { name: "First Name", other: "Sure" }
      expect(obj.to_h).to eq data
    end

    it "should convert nested Arendelle instances" do
      obj = Arendelle.new(
        name: "First Name",
        other: Arendelle.new(
          nested: Arendelle.new(double_nested: "Double Nested")
        )
      )
      data = {
        name: "First Name",
        other: {
          nested: {
            double_nested: "Double Nested"
          }
        }
      }
      expect(obj.to_h).to eq data
    end
  end
end
