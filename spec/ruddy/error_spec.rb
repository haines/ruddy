require "ruddy/error"

module Ruddy
  describe Error do
    describe ".new" do
      after { Error.errnos.clear }

      context "with a known error code" do
        it "returns an instance of a subclass" do
          subclass = Error.define(42, "")
          instance = Error.new("", 42)

          expect(instance).to be_an_instance_of subclass
        end

        it "sets the error number" do
          Error.define 42, ""
          instance = Error.new("", 42)

          expect(instance.errno).to eq 42
        end

        it "sets the message" do
          Error.define 42, "bar"
          instance = Error.new("foo", 42)

          expect(instance.message).to eq "foo - bar"
        end
      end

      context "with an unknown error code" do
        it "returns an instance of itself" do
          instance = Error.new("", 42)

          expect(instance).to be_an_instance_of Error
        end

        it "sets the error number" do
          instance = Error.new("", 42)

          expect(instance.errno).to eq 42
        end

        it "sets the message" do
          instance = Error.new("foo", 42)

          expect(instance.message).to eq "foo - Unknown error"
        end
      end
    end
  end
end
