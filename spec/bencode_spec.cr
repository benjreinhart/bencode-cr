require "./spec_helper"

describe Bencode do
  context "when encoding" do
    context "strings" do
      it "handles empty strings" do
        Bencode.encode("").should eq "0:"
      end

      it "handles non-empty strings" do
        Bencode.encode("hello world").should eq "11:hello world"
      end
    end

    context "integers" do
      it "handles differnt types of positive integers" do
        Bencode.encode(1_i8).should eq "i1e"
        Bencode.encode(1_u8).should eq "i1e"

        Bencode.encode(20_i16).should eq "i20e"
        Bencode.encode(20_u16).should eq "i20e"

        Bencode.encode(100_i32).should eq "i100e"
        Bencode.encode(100_u32).should eq "i100e"

        Bencode.encode(10_000_i64).should eq "i10000e"
        Bencode.encode(10_000_u64).should eq "i10000e"
      end

      it "handles differnt types of negative signed integers" do
        Bencode.encode(-1_i8).should eq "i-1e"
        Bencode.encode(-20_i16).should eq "i-20e"
        Bencode.encode(-100_i32).should eq "i-100e"
        Bencode.encode(-10_000_i64).should eq "i-10000e"
      end
    end

    context "arrays" do
      it "handles an empty list of values" do
        Bencode.encode([] of Bencode::List).should eq "le"
      end

      it "handles a list of values" do
        Bencode.encode(["one", 2, "three"]).should eq "l3:onei2e5:threee"
      end
    end

    context "dictionaries" do
      it "handles an empty dictionary of values" do
        Bencode.encode({} of String => Bencode::Type).should eq "de"
      end

      it "handles a dictionary of key value pairs" do
        Bencode.encode({ "one" => "two", "three" => 4, "five" => -6 }).should eq "d4:fivei-6e3:one3:two5:threei4ee"
      end
    end

    context "recursive structures" do
      it "handles recursive structures" do
        list = [
          "a string",
          { "key" =>
            [
              "one",
              2,
              { "key" => "value" } of String => Bencode::Type
            ] of Bencode::Type,
          } of String => Bencode::Type,
          120
        ]
        Bencode.encode(list).should eq "l8:a stringd3:keyl3:onei2ed3:key5:valueeeei120ee"
      end
    end
  end

  context "when decoding" do
    context "strings" do
      it "is nil when malformed" do
        Bencode.decode("3one").should eq nil
        Bencode.decode(":one").should eq nil
      end

      it "handles an empty string" do
        Bencode.decode("0:").should eq ""
      end

      it "handles non-empty strings" do
        Bencode.decode("11:hello world").should eq "hello world"
      end
    end

    context "integers" do
      it "is nil when malformed" do
        Bencode.decode("ie").should eq nil
      end

      it "handles negative integers" do
        Bencode.decode("i-123e").should eq -123_i64
      end

      it "handles postive integers" do
        Bencode.decode("i123e").should eq 123_i64
      end
    end

    context "lists" do
      it "handles empty lists" do
        expected = [] of Bencode::Type
        Bencode.decode("le").should eq(expected)

        expected = [[] of Bencode::Type, [] of Bencode::Type]
        Bencode.decode("llelee").should eq(expected)

        expected = [[[] of Bencode::Type]]
        Bencode.decode("llleee").should eq(expected)
      end

      it "handles non-empty lists" do
        expected = ["hello", "world", -123] of Bencode::Type
        Bencode.decode("l5:hello5:worldi-123e").should eq(expected)
      end

      it "handles deep, non-empty lists" do
        expected = ["hello", [["world", -123] of Bencode::Type]]
        puts Bencode.decode("l5:helloll5:worldi-123eee").should eq expected
      end
    end

    context "dictionaries" do
      it "is nil when malformed" do
        Bencode.decode("di1e3:onee").should eq nil
      end

      it "handles empty dictionaries" do
        expected = {} of String => Bencode::Type
        Bencode.decode("de").should eq expected
      end

      it "handles non-empty dictionaries" do
        expected = { "key" => "value", "integer" => -10 }
        Bencode.decode("d7:integeri-10e3:key5:valuee").should eq expected
      end

      it "handles deep, non-empty dictionaries" do
        expected = {"key" => { "key2" => { "key3" => "value"} of String => Bencode::Type}}
        Bencode.decode("d3:keyd4:key2d4:key35:valueeee").should eq expected
      end
    end
  end
end
