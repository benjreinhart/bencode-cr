module Bencode::Encode
  def encode(s : String)
     "#{ s.length.to_s }:#{ s }"
  end

  def encode(i : Integer)
    "i#{ i }e"
  end

  def encode(l : List)
    result = l.inject("") { |memo, o| memo + encode(o) }
    "l#{ result }e"
  end

  def encode(d : Dictionary)
    result = d.keys.sort.inject("") { |memo, key| memo + encode(key) + encode(d[key]) }
    "d#{ result }e"
  end
end
