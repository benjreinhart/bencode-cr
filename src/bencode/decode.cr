module Bencode::Decode

  def decode(s : String) : Type?
    read(s).try &.first
  end

  private def read(s) : Result?
    case s[0]?
    when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
      decode_string(s)
    when 'i'
      decode_integer(s)
    when 'l'
      decode_list(s)
    when 'd'
      decode_dictionary(s)
    end
  end

  private def decode_string(s) : Result?
    if match = s.match(/\A(\d+):(.*)$\Z/)
      count, rest = match[1], match[2]
      result = rest[0...count.to_i]
      length = count.length + 1 + count.to_i
      {result as Type, length.to_i64}
    end
  end

  private def decode_integer(s) : Result?
    if match = s.match(/\Ai(-?\d+)e/)
      {match[1].to_i64 as Type, match[0].length.to_i64}
    end
  end

  private def decode_list(s) : Result?
    cursor = 1
    list = [] of Type

    while s[cursor]?.try { |char| char != 'e' }
      if entry = read s[cursor...s.length]
        entry, entry_length = entry
        list << entry
        cursor += entry_length
      else
        return nil
      end
    end

    {list as Type, (cursor + 1).to_i64}
  end

  private def decode_dictionary(s) : Result?
    cursor = 1
    dictionary = {} of String => Type

    while s[cursor]?.try { |char| char != 'e' }
      if key_entry = read s[cursor...s.length]
        key_entry, key_entry_length = key_entry
        return nil unless key_entry.is_a?(String)
        if value_entry = read s[cursor + key_entry_length...s.length]
          value_entry, value_entry_length = value_entry
          dictionary[key_entry] = value_entry as Type
          cursor += key_entry_length + value_entry_length
        else
          return nil
        end
      else
        return nil
      end
    end

    {dictionary as Type, (cursor + 1).to_i64}
  end
end