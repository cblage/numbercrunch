# Numbercrunch

### Running the number parser profiler

        $iex -S mix
        Erlang/OTP 23 [erts-11.1.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]
        Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
        iex(1)> Numbercrunch.profile_parse_numbers

A `number_parsing_profile.fprof` file will be generated in the project dir.

### Running the number counter profiler

        $iex -S mix
        Erlang/OTP 23 [erts-11.1.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]
        Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
        iex(1)> Numbercrunch.profile_number_counter_<A|B>

A `number_counter\_\<A|B>.fprof` file will be generated in the project dir.

### Visualizing results

Providing you have `qcachegrind` installed, you can use the `erlgrind.sh` script that was borrowed from <https://github.com/isacssouza/erlgrind> in the following fashion:

```bash
./erlgrind.sh XXXX.fprof callgrind.XXX
```

Afterwards you should be able to open the generated callgrind file inside `qachegrind`

Inspired by this guide: <http://blog.equanimity.nl/blog/2013/04/24/fprof-kcachegrind/>
