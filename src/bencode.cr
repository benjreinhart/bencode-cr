require "./bencode/*"

module Bencode
  alias Integer = Int8 | UInt8 | Int16 | UInt16 | Int32 | UInt32 | Int64 | UInt64
  alias Type = String | Integer | Array(Type) | Hash(String, Type)
  alias List = Array(Type)
  alias Dictionary = Hash(String, Type)
  alias Result = {Type, Int64}

  extend Bencode::Encode
  extend Bencode::Decode
end
