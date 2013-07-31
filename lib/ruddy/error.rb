module Ruddy
  class Error < StandardError
    def initialize(message, errno)
      super("#{message} - #{description}")
      @errno = errno
    end

    attr_reader :errno

    def self.errnos
      @errnos ||= Hash.new(self)
    end

    def self.define(errno, description)
      errnos[errno] = Class.new(self) do
        define_method(:description) { description }
        private :description
      end
    end

    def self.new(message, errno)
      errnos[errno].allocate.tap{|instance| instance.send :initialize, message, errno }
    end

    private

    def description
      "Unknown error"
    end
  end
end
