#!/usr/bin/env lua
-- Thu Feb 22 10:46:31 2018

-- FUN
-- Functional Tools (Lua)
-- 1.0

-- MIT License
-- Copyright (c) 2018 Alexander Veledzimovich veledz@gmail.com

-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

-- To Do
-- 2.0
-- verbose
-- separate tests
-- improve randval, randkey
-- join with var args

-- Tool Box
-- gkv, lent, clone, copy, range, keys, iskey, isval, equal
-- join, map, mapr, mapx, exem, filter, partial, reduce, compose,
-- randkey, randval, shuffle

-- for old Lua version
local unpack = table.unpack or unpack

local function gkv ( item )
    if type(item) ~= 'table' then return nil end
    for k, v in pairs(item) do
        print(k, v, type(v))
    end
end

local function lent (item)
    if type(item) ~= 'table' then return nil end
    local i = 0
    for _ in pairs(item) do
        i = i + 1
    end
    return i
end

local function clone ( item )
    if type(item) ~= 'table' then return nil end
    local arr = {}
    local meta = getmetatable(item)

    for k, v in pairs(item) do
        if type(v) == 'table' then
            arr[k] = clone(v)
        else
            arr[k] = v
        end
    end
    setmetatable(arr, meta)
    return arr
end

local function range ( start, finish, step )
    start = start or 1
    finish = finish or start+1
    step = step or 1
    local arr = {}
    for i=start, finish, step do arr[i] = i end
    return arr
end

local function copy ( item )
    if type(item) ~= 'table' then return nil end
    local arr = {}
    local meta = getmetatable(item)
    for k, v in pairs(item) do arr[k] = v end
    setmetatable(arr, meta)
    return arr
end

local function keys ( item )
    if type(item) ~= 'table' then return nil end
    local arr = {}
    for k, _ in pairs(item) do
        arr[#arr+1] = k
    end
    return arr
end

local function iskey ( key, item )
    if not key or type(item) ~= 'table' then return false end
    for k, v in pairs(item) do
        if k == key then return {k,v} end
    end
    return false
end

local function isval ( val, item )
    if not val or type(item) ~= 'table' then return false end
    for k, v in pairs(item) do
        if v == val then return {k,v} end
    end
    return false
end

local function equal (item1, item2)
    if type(item1) ~= 'table' or type(item2) ~= 'table' then return nil end
    local len1 = lent(item1)
    local len2 = lent(item2)
    if len1 ~= len2 then return false end
    for i = 1, len1 do
        if item1[i] ~= item2[i] then return false end
    end
    return true
end

local function join ( item1, item2 )
    if not item1 or not item2 then return nil end
    if type(item1) ~= 'table' then item1 = {item1} end
    if type(item2) ~= 'table' then item2 = {item2} end

    local arr = clone(item1)
    local meta = getmetatable(arr)

    for k, v in pairs(item2) do
        if type(k) == 'number' then k = k + #item1 end
        arr[k] = v
    end
    setmetatable(arr, meta)
    return arr
end

local function map ( func, item )
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        arr[k] = func(v)
    end
    return arr
end

local function mapr ( func, item )
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        if type(v) == 'table' then
            arr[k] = mapr(func, v)
        else
            arr[k] = func(v)
        end
    end
    return arr
end


local function mapx ( func, item )
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        arr[k] = function () return func(v) end
    end
    return arr
end

local function exem ( item )
    if type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        if type(v) ~= 'function' then arr[k] = v end
        arr[k] = v()
    end
    return arr
end


local function filter ( func, item )
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        if func(v) then arr[k] = v end
    end
    return arr
end

local function partial ( func, ... )
    if type(func) ~= 'function' then return nil end
    local args = { ... }

    local function inner ( ... )
        local new_args = { ... }
        local res = join(args, new_args)

        return func(unpack(res, 1, lent(res)))
    end
    return inner
end

local function reduce ( func, item )
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local res = nil
    local first = item[1]
    for i = 2, lent(item) do
        res = func(first, item[i])
        first = res
    end
    return res
end

local function compose ( func, wrap )
    if type(func) ~= 'function' then return nil end
    local function inner ( ... )
        return reduce(function(x, y) return  y(x) end, {wrap( ... ), func})
    end
    return inner
end

local function randkey ( item )
    if type(item) ~= 'table' then return nil end
    math.randomseed(os.time())
    local index = math.random(1, lent(item))
    return keys(item)[index]
end

local function randval ( item )
    return item[randkey(item)]
end

local function shuffle( item )
    if type(item) ~= 'table' then return nil end
    local arr = {}
    for i=1, lent(item) do
        local index = randkey(item)
        local key = index
        if type(index) == 'number' then key = i end
        arr[key] = item[index]
        item[index] = nil
    end
    return arr
end

-- test
local function test  ()
    print('when wrong values', gkv('lua', {42}))

    local target = {0, 1, gkv, 'whoami', ['lua'] = 'moon', ['bit'] = {0, 1}}

    print('gkv')
    gkv(target)
    print('\nlent', lent(target), #target)

    local a = clone(target)
    local b = clone(target)

    print('\nclone',a ~= b)
    print('deep clone', a['bit'] ~= b['bit'])

    a = copy(target)
    b = copy(target)
    print('\ncopy', a ~= b)
    print('copy first level', a['bit'] ~= b['bit'])

    print('\nrange')
    gkv((range(1,5,2)))

    print('\nkeys')
    gkv((keys(target)))

    print('\niskey', iskey('bit', target)~=nil)
    print('\nisval')
    gkv(iskey('lua', target))

    print('\nequal', equal(a, b))
    local complex_eq = partial(equal, {1,1})

    gkv(map(complex_eq, {{1,0},{0,1},{0,0},{1,1}}))


    print('\njoin')
    print('no args',join())
    gkv(join(target, {'join', zero = 0}))
    print('join tables and values')
    gkv(join({1,0}, 42))

    print('\nmap')
    gkv(map(table.concat, { {'map'}, {0,1} }))
    gkv(map(tostring, range(1,3)))
    print('len all items')
    gkv(map(string.len, map(tostring, target)))
    print('print values')
    map(print, target)

    print('\nmapx')
    local python3_map = mapx(tostring, target)
    gkv(python3_map)
    print('\nexem')
    gkv(exem(mapx(string.len, exem(python3_map))))

    print('\nmapr')
    local recursive = mapr(tostring, target)
    gkv(recursive)
    print('string in table')
    gkv(recursive['bit'])
    print('print all items recursevly')
    mapr(print, target)
    print('len all items recursevly')
    gkv(map(string.len, map(tostring, join(recursive, recursive['bit']))))

    local array = {16, 32, 64}
    local mixarr = {'moon', 'lua', 42}
    print('\nfilter')
    print('string only')
    gkv(filter(function(x) return type(x) == 'string' end, mixarr))
    print('> 0')
    gkv(filter(function (x) return x > 32 end, array))
    print('len > 3')
    gkv(filter(function(x) return tostring(x):len() > 3 end , mixarr))

    print('\nreduce')
    local nested = {{1,0},{0,1},{0,0},1,1}
    print(reduce(function(x, y) return  x + y end, {1,1}))
    print(reduce(function(x, y) return  x + y end, {1,2,4,8,16,32,64,128}))
    print('flat table')
    gkv(reduce(join,nested))

    print('\npartial')
    print('make print # function')
    local print_she = partial(print, '#')
    print_she('whoami','code')
    print('make map to string function')
    local mapstr = partial(map, tostring)
    gkv(mapstr(array))
    print('make filter for numbers')
    local filter_str = partial(filter,
                               function(x) return type(x) == 'number' end)
    gkv(filter_str(mixarr))
    print('make lent for all items')
    local maplent = partial(map, string.len)

    print('\ncompose')
    print('exclude gkv')
    local no_gkv = compose(gkv, mapstr)
    no_gkv(mixarr)
    print('exclude lent')
    local no_lent = compose(maplent, compose(mapstr, filter_str))
    gkv(no_lent(mixarr))

    print('\nrandkey', target[randkey(target)])
    print('\nrandval', randval(target))

    print('\nshuffle')
    gkv(shuffle(mixarr))

end

-- test ()

return { ['gkv'] = gkv, ['lent'] = lent,
        ['clone'] = clone, ['copy'] = copy,
        ['range'] = range, ['keys'] = keys,
        ['iskey'] = iskey, ['isval'] = isval,
        ['equal'] = equal, ['join'] = join,
        ['map'] = map, ['mapx'] = mapx,
        ['exem'] = exem, ['mapr'] = mapr,
        ['filter'] = filter, ['reduce'] = reduce,
        ['partial'] = partial, ['compose'] = compose,
        ['randkey'] = randkey, ['randval'] = randval,
        ['shuffle'] = shuffle }
