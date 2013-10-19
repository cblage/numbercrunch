defmodule Numbercrunch do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Numbercrunch.Supervisor.start_link
  end

  def run_test do
    IO.puts "Preparing to count some numbers!"
    {:ok, binary} = File.read "rand.txt"
    IO.puts "Test file loaded."
    

    IO.puts "Counting integers..."
    count_integers_start = :erlang.now()
    integer_count = count_integers(binary)
    count_integers_stop = :erlang.now()
    IO.puts "Done counting integers."
    

    IO.puts "Counting floats..."
    count_floats_start = :erlang.now()
    float_count = count_floats(binary)
    count_floats_stop = :erlang.now()
    IO.puts "Done counting floats."

    integer_time = :timer.now_diff(count_integers_stop, count_integers_start) / 1000000
    float_time   = :timer.now_diff(count_floats_stop, count_floats_start) / 1000000
    
    IO.puts "Test finished"
    IO.puts "Integer count: #{integer_count}, time to count: #{integer_time}s"
    IO.puts "Float count: #{float_count}, time to count: #{float_time}s"
  end

  defp count_floats(bin), do: count_floats(bin, 0)

  defp count_floats(<< >>, acc), do: acc

  defp count_floats(<< _ , rest :: binary >> = bin, acc) do 
    case Float.parse(bin) do 
      :error -> count_floats(rest, acc)
      {_, remainder} -> count_floats(remainder, acc + 1)
    end
  end

  defp count_integers(bin), do: count_integers(bin, 0)

  defp count_integers(<< >>, acc), do: acc

  defp count_integers(<< _ , rest :: binary >> = bin, acc) do
    case Integer.parse(bin) do 
      :error -> count_integers(rest, acc)
      {_, remainder} -> count_integers(remainder, acc + 1)
    end
  end
end
