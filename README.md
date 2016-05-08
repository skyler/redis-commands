Custom Redis Commands
=======================

Lua scripts for doing various things in Redis. Use these with `EVAL` and
`EVALSHA` etc.

### `SRANDMEMBERSTORE.lua`
Pick a random number of members from a set and store them in another set.

### `SUNIONSTORE_ZSCORE_KEYS.lua`
Store the union of sets whose keys are themselves stored in a separate sorted
set. The keys to store are determined by a numeric comparison between a min
and max range.

### `ZRANGESTORE.lua`
Store the results of ZRANGE to a new unsorted set.

### `ZREM_SCARD.lua`
Given a sorted set which contains, as strings, keys of other unsorted sets,
remove a value from the sorted set when the unsorted set is empty.
