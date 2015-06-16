# bencode

Solution for encoding and decoding the Bencode format in the [Crystal language](http://crystal-lang.org).

* [BitTorrent Specification](http://wiki.theory.org/BitTorrentSpecification)
* [Bencode](http://en.wikipedia.org/wiki/Bencode)

## Installation

Add it to `Projectfile`

```crystal
deps do
  github "benjreinhart/bencode-cr"
end
```

## Usage

```crystal
require "bencode"
```

#### Bencode#encode(s : String) : String
#### Bencode#encode(i : Bencode::Integers) : String
#### Bencode#encode(l : Bencode::List) : String
#### Bencode#encode(d : Bencode::Dictionary) : String


```crystal
Bencode.encode("string")             # => "6:string"
Bencode.encode(123)                  # => "i123e"
Bencode.encode(["str", 123])         # => "l3:stri123ee"
Bencode.encode({ "key" => "value" }) # => "d3:key5:valuee"
```

#### Bencode#decode(s : String) : Bencode::Type?

```crystal
Bencode.decode("") # => nil
Bencode.decode("di4e5:valuee") # => nil (invalid dictionary)
Bencode.decode("d3:key5:valuee") # => { "key" => "value" }
```

## Contributing

1. Fork it ( https://github.com/benjreinhart/bencode/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

