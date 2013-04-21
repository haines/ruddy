require "ffi"
require "dde/constants"

module DDE
  extend FFI::Library
  ffi_lib "user32"
  ffi_convention :stdcall

# HDDEDATA CALLBACK DdeCallback(
#   _In_  UINT uType,
#   _In_  UINT uFmt,
#   _In_  HCONV hconv,
#   _In_  HSZ hsz1,
#   _In_  HSZ hsz2,
#   _In_  HDDEDATA hdata,
#   _In_  ULONG_PTR dwData1,
#   _In_  ULONG_PTR dwData2
# );
  callback :dde_callback, [:uint, :uint, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :pointer

# UINT WINAPI DdeInitialize(
#   _Inout_     LPDWORD pidInst,
#   _In_        PFNCALLBACK pfnCallback,
#   _In_        DWORD afCmd,
#   _Reserved_  DWORD ulRes
# );
  attach_function :start, :DdeInitializeA, [:pointer, :dde_callback, :uint, :uint], :uint

# BOOL WINAPI DdeUninitialize(
#   _In_  DWORD idInst
# );
  attach_function :stop, :DdeUninitialize, [:uint], :bool

# HSZ WINAPI DdeCreateStringHandle(
#   _In_  DWORD idInst,
#   _In_  LPTSTR psz,
#   _In_  int iCodePage
# );
  attach_function :create_string_handle, :DdeCreateStringHandleA, [:uint, :pointer, :int], :pointer

# HCONV WINAPI DdeConnect(
#   _In_      DWORD idInst,
#   _In_      HSZ hszService,
#   _In_      HSZ hszTopic,
#   _In_opt_  PCONVCONTEXT pCC
# );
  attach_function :connect, :DdeConnect, [:uint, :pointer, :pointer, :pointer], :pointer

# HDDEDATA WINAPI DdeClientTransaction(
#   _In_opt_   LPBYTE pData,
#   _In_       DWORD cbData,
#   _In_       HCONV hConv,
#   _In_opt_   HSZ hszItem,
#   _In_       UINT wFmt,
#   _In_       UINT wType,
#   _In_       DWORD dwTimeout,
#   _Out_opt_  LPDWORD pdwResult
# );
  attach_function :client_transaction, :DdeClientTransaction, [:pointer, :uint, :pointer, :pointer, :uint, :uint, :uint, :pointer], :pointer

# UINT WINAPI DdeGetLastError(
#   _In_  DWORD idInst
# );
  attach_function :last_error, :DdeGetLastError, [:uint], :uint

# BOOL WINAPI DdeFreeDataHandle(
#   _In_  HDDEDATA hData
# );
  attach_function :free_data_handle, :DdeFreeDataHandle, [:pointer], :bool

# BOOL WINAPI DdeFreeStringHandle(
#   _In_  DWORD idInst,
#   _In_  HSZ hsz
# );
  attach_function :free_string_handle, :DdeFreeStringHandle, [:uint, :pointer], :bool
end
