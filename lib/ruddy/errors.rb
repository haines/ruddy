module Ruddy
  AdviseTimeoutError = Error.define(0x4000, "A request for a synchronous advise transaction has timed out.")

  BusyError = Error.define(0x4001, "The response to the transaction caused the DDE_FBUSY flag to be set.")

  DataTimeoutError = Error.define(0x4002, "A request for a synchronous data transaction has timed out.")

  DLLNotInitializedError = Error.define(0x4003, "A DDEML function was called without first calling the DdeInitialize function, or an invalid instance identifier was passed to a DDEML function.")

  DLLUsageError = Error.define(0x4004, "An application initialized as APPCLASS_MONITOR has attempted to perform a DDE transaction, or an application initialized as APPCMD_CLIENTONLY has attempted to perform server transactions.")

  ExecutionTimeoutError = Error.define(0x4005, "A request for a synchronous execute transaction has timed out.")

  InvalidParameterError = Error.define(0x4006, "A parameter failed to be validated by the DDEML. Some of the possible causes follow:
                                                The application used a data handle initialized with a different item name handle than was required by the transaction.
                                                The application used a data handle that was initialized with a different clipboard data format than was required by the transaction.
                                                The application used a client-side conversation handle with a server-side function or vice versa.
                                                The application used a freed data handle or string handle.
                                                More than one instance of the application used the same object.")

  LowMemoryError = Error.define(0x4007, "A DDEML application has created a prolonged race condition (in which the server application outruns the client), causing large amounts of memory to be consumed.")

  MemoryError = Error.define(0x4008, "A memory allocation has failed.")

  NoConversationEstablishedError = Error.define(0x400A, "A client's attempt to establish a conversation has failed.")

  NotProcessedError = Error.define(0x4009, "A transaction has failed.")

  PokeTimeoutError = Error.define(0x400B, "A request for a synchronous poke transaction has timed out.")

  PostMessageFailedError = Error.define(0x400C, "An internal call to the PostMessage function has failed.")

  ReentrancyError = Error.define(0x400D, "An application instance with a synchronous transaction already in progress attempted to initiate another synchronous transaction, or the DdeEnableCallback function was called from within a DDEML callback function.")

  ServerDiedError = Error.define(0x400E, "A server-side transaction was attempted on a conversation terminated by the client, or the server terminated before completing a transaction.")

  SystemError = Error.define(0x400F, "An internal error has occurred in the DDEML.")

  UnadviseTimeoutError = Error.define(0x4010, "A request to end an advise transaction has timed out.")

  QueueNotFoundError = Error.define(0x4011, "An invalid transaction identifier was passed to a DDEML function. Once the application has returned from an XTYP_XACT_COMPLETE callback, the transaction identifier for that callback function is no longer valid.")
end
