defmodule Huffman do

  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end


  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do freq(sample, %{}) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do
    updated_map = Map.update(freq, char, 1, &(&1 + 1))
    freq(rest, updated_map)
  end


  def huffman(freq) do
      build_tree(Enum.sort_by(freq, fn {_, f} -> f end))
  end

  def build_tree([{char1, _}]) do char1 end

  def build_tree([{char1, freq1}, {char2, freq2} | rest]) do
    build_tree(insert({{char1, char2}, freq1 + freq2}, rest))
  end

  def insert({char, freq}, []) do [{char, freq}] end

  def insert({char1, freq1}, [{char2, freq2} | rest]) do
      if freq1 < freq2 do
         [{char1, freq1}, {char2, freq2} | rest]
      else
         [{char2, freq2} | insert({char1, freq1}, rest)]
      end
  end


  def encode_table(tree) do generate_codes(tree,[]) end

  def generate_codes({left, right}, path) do
    generate_codes(left, [0 | path]) ++
    generate_codes(right, [1 | path])
  end

  def generate_codes(char, path) do [{char, Enum.reverse(path)}] end

  def decode_table(tree) do
    encode_table(tree)
  end


  def encode([], _) do [] end
  def encode([char | rest], table) do
    find(char, table) ++ encode(rest, table)
  end

  def find(_, []) do [] end
  def find(char, [{char, path} | _]) do path end
  def find(char, [_ | rest]) do find(char, rest) end


  def decode([], _) do [] end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do
      {char, _} -> {char, rest}
      nil -> decode_char(seq, n + 1, table)
    end
  end


  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, _} ->
       list
    list ->
       list
      end
  end


      def bench() do
        file = read("data.txt")
        t0 = :os.system_time(:millisecond)
        tree = tree(file)
        t1 = :os.system_time(:millisecond)
        tree_t = t1-t0
        t0 = :os.system_time(:millisecond)
        encode = encode_table(tree)
        t1 = :os.system_time(:millisecond)
        encode_t = t1-t0
        t0 = :os.system_time(:millisecond)
        seq = encode(file, encode)
        t1 = :os.system_time(:millisecond)
        seq_t = t1-t0
        t0 = :os.system_time(:millisecond)
        decode(seq, encode)
        t1 = :os.system_time(:millisecond)
        decode_t = t1-t0
        :io.format("File size ~w~nComprimized size ~w~nThe time it took to make a tree: ~w~nThe time it took to make encode table: ~w~nThe time it took to encode kallocain: ~w~nThe time it took to decode kallocain: ~w~n", [length(file),div(length(seq),8), tree_t, encode_t, seq_t,decode_t])
      end

end
