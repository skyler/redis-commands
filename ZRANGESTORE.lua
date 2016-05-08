-- Store the results of ZRANGE to a new unsorted set.
-- If destination already exists, it is overwritten.
-- Returns the number of elements in the resulting set.

local zset  = KEYS[1] -- The sorted set.
local dest  = KEYS[2] -- The destination key.
local start = ARGV[1] -- Sorted set range start index.
local stop  = ARGV[2] -- Sorted set range stop index.
local byscore = ARGV[3] -- FIXME

-- see: http://pastebin.com/8Z2SQ9F2
local MAX_UNPACK = 7999

redis.call("del", dest)

local members
if byscore == "byscore" then
    members = redis.call("zrangebyscore", zset, start, stop)
else
    members = redis.call("zrange", zset, start, stop)
end

local len = #members
if len > MAX_UNPACK then
    local tmp = {}
    local pos = 1
    for i = 1, len do
        tmp[pos] = members[i]
        pos = pos + 1
        if math.fmod(i, MAX_UNPACK) == 0 then
            redis.call("sadd", dest, unpack(tmp))
            tmp = {}
            pos = 1
        end
    end
elseif len > 0 then
    redis.call("sadd", dest, unpack(members))
end
return len
