module Ruddy
  class Connection

    attr_reader :service, :topic
    attr_accessor :timeout

    def initialize(service, topic, options = {})
      @service = service
      @topic   = topic
      @timeout = options.fetch(:timeout, 3000)

      start
      connect
    end

    def close
      @closed = true
      DDE.stop(instance)
    end

    def closed?
      @closed
    end

    def execute(command)
      raise IOError.new("closed connection") if closed?

      buffer = FFI::MemoryPointer.from_string(command)
      result = FFI::MemoryPointer.new(:uint)

      data = DDE.client_transaction(buffer, buffer.size, conversation, nil, 0, DDE::XTYP_EXECUTE, timeout, result)
      raise Error.new("command execution failed", DDE.last_error(instance)) if data.null?
      DDE.free_data_handle(data)

      return result.read_uint
    end

    def self.open(*args)
      connection = new(*args)
      return connection unless block_given?

      begin
        yield connection
      ensure
        connection.close
      end
    end

    private

    attr_reader :instance, :conversation

    CALLBACK = ->(*){}

    def start
      instance = FFI::MemoryPointer.new(:uint)
      error = DDE.start(instance, CALLBACK, DDE::APPCLASS_STANDARD | DDE::APPCMD_CLIENTONLY, 0)
      raise Error.new("DDE management library initialization failed", error) if error != DDE::DMLERR_NO_ERROR
      @instance = instance.read_uint
    end

    def connect
      service_handle = create_string_handle(service)
      topic_handle = create_string_handle(topic)

      @conversation = DDE.connect(instance, service_handle, topic_handle, nil)

      free_string_handle service_handle
      free_string_handle topic_handle

      raise Error.new(%{could not connect to DDE service "#{service}"}, DDE.last_error(instance)) if conversation.null?
    end

    def create_string_handle(string)
      DDE.create_string_handle(instance, string, DDE::CP_WINANSI)
    end

    def free_string_handle(handle)
      DDE.free_string_handle(instance, handle)
    end

  end
end
