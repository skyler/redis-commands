-- Store the union of sets whose keys are themselves stored in a separate sorted set.
-- The keys to store are determined by a numeric comparison between a min and max range.
-- Returns the number of items stored in dest_key.

local zset_key   = KEYS[1] -- The name of the sorted set where other set keys are stored.
local dest_key   = KEYS[2] -- Where the union result should be stored.
local zrange_min = ARGV[1] -- The min value for the range search.
local zrange_max = ARGV[2] -- The max value for the range search.

local keys = redis.call("zrangebyscore", zset_key, zrange_min, zrange_max)

-- FIXME: if there are more than 7999 keys then unpack will error!
if #keys > 0 then
    return redis.call("sunionstore", dest_key, unpack(keys))
else
    return 0
end
