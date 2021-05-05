defmodule Numbercrunch do
  use Application

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def profile_number_counter_A do
    IO.puts("Preparing to test encoding and decoding.")
    {:ok, binary} = File.read("rand.txt")
    IO.puts("Test file loaded, test begins...")

    consecutive_numbers_start = :erlang.now()
    :fprof.start()
    :fprof.trace([:start])

    consecutive_numbers = count_consecutive_numbers_A(binary)

    :fprof.trace([:stop])

    consecutive_numbers_stop = :erlang.now()

    consecutive_numbers_time =
      :timer.now_diff(consecutive_numbers_stop, consecutive_numbers_start) / 1_000_000

    IO.puts("Test finished")

    IO.puts(
      "Consecutive numbers count: #{consecutive_numbers}, took: #{consecutive_numbers_time}s"
    )

    :fprof.profile()
    :fprof.analyse({:dest, 'number_counter_A.fprof'})
    :fprof.stop()
  end

  defp count_consecutive_numbers_A(binary) when is_binary(binary) do
    count_consecutive_numbers_A(binary, 0)
  end

  defp count_consecutive_numbers_A(<<>>, acc), do: acc

  defp count_consecutive_numbers_A(<<char_a, char_b, after_char_b::binary>>, acc)
       when char_a in ?0..?9 do
    if char_b in ?0..?9 do
      count_consecutive_numbers_A(<<char_b, after_char_b::binary>>, acc + 1)
    else
      count_consecutive_numbers_A(<<char_b, after_char_b::binary>>, acc)
    end
  end

  ## consume what we don't need
  defp count_consecutive_numbers_A(<<_, rest::binary>>, acc) do
    count_consecutive_numbers_A(rest, acc)
  end

  def profile_number_counter_B do
    IO.puts("Preparing to test encoding and decoding.")
    {:ok, binary} = File.read("rand.txt")
    IO.puts("Test file loaded, test begins...")

    consecutive_numbers_start = :erlang.now()
    :fprof.start()
    :fprof.trace([:start])

    consecutive_numbers = count_consecutive_numbers_B(binary)

    :fprof.trace([:stop])

    consecutive_numbers_stop = :erlang.now()

    consecutive_numbers_time =
      :timer.now_diff(consecutive_numbers_stop, consecutive_numbers_start) / 1_000_000

    IO.puts("Test finished")

    IO.puts(
      "Consecutive numbers count: #{consecutive_numbers}, took: #{consecutive_numbers_time}s"
    )

    :fprof.profile()
    :fprof.analyse({:dest, 'number_counter_B.fprof'})
    :fprof.stop()
  end

  @test_string "lala12rsggdsg45653c"

  def test_A do
    count_consecutive_numbers_A(@test_string |> IO.inspect())
  end

  def test_B do
    count_consecutive_numbers_B(@test_string |> IO.inspect())
  end

  defp count_consecutive_numbers_B(binary) when is_binary(binary) do
    count_consecutive_numbers_B(binary, 0)
  end

  defp count_consecutive_numbers_B(<<>>, acc), do: acc

  defp count_consecutive_numbers_B(<<char_a, after_char_a::binary>>, acc) when char_a in ?0..?9 do
    <<char_b, _::binary>> = after_char_a

    if char_b in ?0..?9 do
      count_consecutive_numbers_B(after_char_a, acc + 1)
    else
      count_consecutive_numbers_B(after_char_a, acc)
    end
  end

  ## consume what we don't need
  defp count_consecutive_numbers_B(<<_, rest::binary>>, acc) do
    count_consecutive_numbers_B(rest, acc)
  end

  def parse_numbers do
    IO.puts("Preparing to count some numbers!")
    {:ok, binary} = File.read("rand.txt")
    IO.puts("Test file loaded.")

    IO.puts("Counting integers...")
    count_integers_start = :erlang.now()
    integer_count = count_integers(binary)
    count_integers_stop = :erlang.now()
    IO.puts("Done counting integers.")

    IO.puts("Counting floats...")
    count_floats_start = :erlang.now()
    float_count = count_floats(binary)
    count_floats_stop = :erlang.now()
    IO.puts("Done counting floats.")

    integer_time = :timer.now_diff(count_integers_stop, count_integers_start) / 1_000_000
    float_time = :timer.now_diff(count_floats_stop, count_floats_start) / 1_000_000

    IO.puts("Test finished")
    IO.puts("Integer count: #{integer_count}, time to count: #{integer_time}s")
    IO.puts("Float count: #{float_count}, time to count: #{float_time}s")
    :ok
  end

  def profile_parse_numbers do
    IO.puts("Preparing to profile number parsing")
    parse_numbers_start = :erlang.now()
    :fprof.start()
    :fprof.trace([:start])

    :ok = parse_numbers()

    :fprof.trace([:stop])

    parse_numbers_stop = :erlang.now()

    parse_numbers_time = :timer.now_diff(parse_numbers_stop, parse_numbers_start) / 1_000_000

    :fprof.profile()
    :fprof.analyse({:dest, 'number_parsing_profile.fprof'})
    :fprof.stop()

    IO.puts("Profilng finished after #{parse_numbers_time}s, check number_parsing_profile.fprof")
  end

  defp count_floats(bin), do: count_floats(bin, 0)

  defp count_floats(<<>>, acc), do: acc

  defp count_floats(<<_, rest::binary>> = bin, acc) do
    case Float.parse(bin) do
      :error -> count_floats(rest, acc)
      {_, remainder} -> count_floats(remainder, acc + 1)
    end
  rescue
    _e in ArgumentError ->
      count_floats(rest, acc)
  end

  defp count_integers(bin), do: count_integers(bin, 0)

  defp count_integers(<<>>, acc), do: acc

  defp count_integers(<<_, rest::binary>> = bin, acc) do
    case Integer.parse(bin) do
      :error -> count_integers(rest, acc)
      {_, remainder} -> count_integers(remainder, acc + 1)
    end
  end
end
