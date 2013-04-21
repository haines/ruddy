require "dde/constants"

module DDE
  module_function

  def start(*)
    DDE::DMLERR_NO_ERROR
  end

  def connect(*)
    FFI::MemoryPointer.new(:uint)
  end

  def stop(*) end

  def create_string_handle(*) end
  def free_string_handle(*) end

  def free_data_handle(*) end

  def last_error(*) end
end
