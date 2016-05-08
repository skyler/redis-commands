-- pick a random number of members from a set and store them in another set.
-- Returns an integer which is the number of elements added to dest_key.

-- set_key and dest_key cannot be the same. dest_key is deleted before anything
-- is added to it.
local set_key     = KEYS[1] -- The name of the set to pull random members from.
local dest_key    = ARGV[1] -- The name of the key to store the selected members.
local limit       = tonumber(ARGV[2]) -- The number of random members to select.
local random_seed = tonumber(ARGV[3]) -- A random number to seed Lua's random number generator.

redis.call("del", dest_key)

local set_size = redis.call("scard", set_key)
if limit >= set_size then
    return redis.call("sunionstore", dest_key, set_key)
end

-- LUAI_MAXCSTACK is 8000 which limits the number of arguments that we can
-- pass to unpack(). Attempting to unpack() more elements than this max this
-- will cause this script to error.
-- see: http://pastebin.com/8Z2SQ9F2
local MAX_UNPACK = 7999

local members = redis.call("smembers", set_key)

math.randomseed(random_seed)

-- from http://snippets.luacode.org/snippets/Shuffle_array_145
local shuffler = function(tab)
    local n, order, res = #tab, {}, {}
     
    for i=1,n do order[i] = { rnd = math.random(), idx = i } end
    table.sort(order, function(a,b) return a.rnd < b.rnd end)
    for i=1,n do res[i] = tab[order[i].idx] end
    return res
end

-- Shuffling the entire list in-place is *much* faster than iterating over the
-- original (unshuffled) table and selecting random elements to fill res{}.
local shuffled = shuffler(members)

local res = {}
local idx
for i = 1, limit do
    idx = #res+1
    res[idx] = shuffled[idx]
    if math.fmod(i, MAX_UNPACK) == 0 then
        redis.call("sadd", dest_key, unpack(res))
        res = {}
    end
end

redis.call("sadd", dest_key, unpack(res))
return limit
