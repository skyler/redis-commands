-- Given a sorted set which contains, as strings, keys of other unsorted sets,
-- remove a value from the sorted set when the unsorted set is empty.

local zset_key = KEYS[1] -- The sorted set that stores the other sets' names.
local set_key  = KEYS[2] -- The key whose cardinality we're checking.

local res = redis.call("scard", set_key)
if res == 0 then
    res = redis.call("zrem", zset_key, set_key)
end
