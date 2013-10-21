# Numbercrunch

### Running the number parser benchmark
        $iex -S mix
        Erlang R16B02 (erts-5.10.3) [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]
        Interactive Elixir (0.10.4-dev) - press Ctrl+C to exit (type h() ENTER for help)
        iex(1)> Numbercrunch.parse_numbers

### Running the number counter profiler
        $iex -S mix
        Erlang R16B02 (erts-5.10.3) [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]
        Interactive Elixir (0.10.4-dev) - press Ctrl+C to exit (type h() ENTER for help)
        iex(1)> Numbercrunch.profile_number_counter_<A|B> 

A "number\_counter\_\<A|B>.fprof" file will be generated in the project dir. 
I suggest following this guide to transform it into the callgrind format and checking the results in kcachegrind: 
<http://blog.equanimity.nl/blog/2013/04/24/fprof-kcachegrind/>
