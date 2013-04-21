# Ruddy

Basic Win32 DDE client in Ruby.

## Installation

    $ gem install ruddy

## Usage

Connect to a DDE server using the `Ruddy::Connection.open` method, and call `execute` on the yielded connection:

```ruby
require "ruddy"

Ruddy::Connection.open("SERVICE", "topic") do |connection|
  connection.execute("command")
end
```
