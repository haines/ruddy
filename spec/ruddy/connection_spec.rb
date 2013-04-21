require "ruddy/connection"
require "ffi"

require "support/fake_dde"
require "support/string_pointer_matcher"

module Ruddy
  describe Connection do
    describe ".new" do
      it "sets the service" do
        connection = Connection.new("MY_SERVICE", "my_topic")

        expect(connection.service).to eq "MY_SERVICE"
      end

      it "sets the topic" do
        connection = Connection.new("MY_SERVICE", "my_topic")

        expect(connection.topic).to eq "my_topic"
      end

      describe "timeout option" do
        it "sets the timeout" do
          connection = Connection.new("MY_SERVICE", "my_topic", timeout: 1000)

          expect(connection.timeout).to eq 1000
        end

        it "defaults to 3 sec" do
          connection = Connection.new("MY_SERVICE", "my_topic")

          expect(connection.timeout).to eq 3000
        end
      end

      it "connects to the service" do
        stub_instance 42

        service_handle = stub("service_handle")
        DDE.stub(:create_string_handle).with(42, "MY_SERVICE", DDE::CP_WINANSI).and_return(service_handle)

        topic_handle = stub("topic_handle")
        DDE.stub(:create_string_handle).with(42, "my_topic", DDE::CP_WINANSI).and_return(topic_handle)

        DDE.should_receive(:connect).with(42, service_handle, topic_handle, nil).and_return(valid_pointer)
        Connection.new("MY_SERVICE", "my_topic")
      end

      context "when initializing the DDE management library fails" do
        it "raises an error" do
          DDE.stub start: 0x4006
          expect{Connection.new("MY_SERVICE", "my_topic")}.to raise_error SystemCallError, /DDE management library initialization failed/
        end

        it "sets the error code" do
          DDE.stub start: 0x4006
          begin
            Connection.new("MY_SERVICE", "my_topic")
          rescue SystemCallError => error
            expect(error.errno).to eq 0x4006
          end
        end
      end

      context "when the connection fails" do
        it "raises an error" do
          DDE.stub connect: null_pointer
          expect{Connection.new("MY_SERVICE", "my_topic")}.to raise_error SystemCallError, /could not connect to DDE service "MY_SERVICE"/
        end
      end
    end

    describe "#close" do
      it "uninitializes the DDE management library" do
        stub_instance 42
        connection = Connection.new("MY_SERVICE", "my_topic")

        DDE.should_receive(:stop).with(42)
        connection.close
      end
    end

    describe "#closed?" do
      it "is false initially" do
        connection = Connection.new("MY_SERVICE", "my_topic")

        expect(connection).not_to be_closed
      end

      it "is true after closing" do
        connection = Connection.new("MY_SERVICE", "my_topic")
        connection.close

        expect(connection).to be_closed
      end
    end

    describe "#execute" do
      it "executes the given command" do
        conversation = valid_pointer
        DDE.stub connect: conversation
        connection = Connection.new("MY_SERVICE", "my_topic", timeout: 12345)
        command = "[Foo(bar)]"

        DDE.should_receive(:client_transaction).with(string_pointer(command), command.length + 1, conversation, nil, 0, DDE::XTYP_EXECUTE, 12345, kind_of(FFI::MemoryPointer)).and_return(valid_pointer)
        connection.execute(command)
      end

      it "returns the result" do
        connection = Connection.new("MY_SERVICE", "my_topic")
        DDE.stub :client_transaction do |*, result|
          result.write_uint 43
        end

        expect(connection.execute("[Foo(bar)]")).to eq 43
      end

      it "frees the returned data structure" do
        connection = Connection.new("MY_SERVICE", "my_topic")
        data = valid_pointer
        DDE.stub client_transaction: data

        DDE.should_receive(:free_data_handle).with(data)
        connection.execute("[Foo(bar)]")
      end

      context "when the execution fails" do
        it "raises an error" do
          connection = Connection.new("MY_SERVICE", "my_topic")
          DDE.stub client_transaction: null_pointer

          expect{connection.execute("[Foo(bar)]")}.to raise_error SystemCallError, /command execution failed/
        end

        it "sets the error code" do
          stub_instance 42
          connection = Connection.new("MY_SERVICE", "my_topic")
          DDE.stub(:last_error).with(42).and_return(0x4000)
          DDE.stub client_transaction: null_pointer

          begin
            connection.execute("[Foo(bar)]")
          rescue SystemCallError => error
            expect(error.errno).to eq 0x4000
          end
        end
      end

      context "when the connection is closed" do
        it "raises an error" do
          connection = Connection.new("MY_SERVICE", "my_topic")
          connection.close

          expect{connection.execute("[Foo(bar)]")}.to raise_error IOError, /closed connection/
        end
      end
    end

    describe ".open" do
      context "with a block" do
        it "yields a connection" do
          yielded = false
          Connection.open("MY_SERVICE", "my_topic") do |connection|
            yielded = connection
          end

          expect(yielded).to be_a Connection
        end

        it "closes the connection afterwards" do
          yielded = false
          Connection.open("MY_SERVICE", "my_topic") do |connection|
            expect(connection).not_to be_closed
            yielded = connection
          end

          expect(yielded).to be_closed
        end
      end

      context "without a block" do
        it "returns an open connection" do
          connection = Connection.open("MY_SERVICE", "my_topic")

          expect(connection).to be_a Connection
          expect(connection).not_to be_closed
        end
      end
    end

    def stub_instance(instance)
      DDE.stub :start do |pointer, *|
        pointer.write_uint instance
        DDE::DMLERR_NO_ERROR
      end
    end

    def valid_pointer
      FFI::MemoryPointer.new(:uint)
    end

    def null_pointer
      stub(null?: true)
    end
  end
end
