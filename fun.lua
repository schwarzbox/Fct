#!/usr/bin/env lua
-- FUN
-- 2.0
-- Functional Tools (Lua)
-- fun.lua

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

-- 2.0
-- check metatables
-- copy vs clone

-- 3.0
-- for 1 func
-- verbose
-- separate tests
-- save functions

-- Tool Box
-- gkv, lent, keys, iskey, isval, array, range, repl
-- split, reverse, slice, sep, clone, copy, iter, equal, join, merge,
-- map, mapr, mapx, exem, filter, any, all, zip, partial, reduce, compose,
-- randkey, randval, shuff, shuffknuth

-- old lua version
local unpack = table.unpack or unpack
-- seed
math.randomseed(os.time())

local function gkv(item)
    if type(item) ~= 'table' then return nil end
    for k, v in pairs(item) do
        print(k, v, type(v))
    end
end

local function lent(item)
    if type(item) ~= 'table' then return nil end
    local len = 0
    for _ in pairs(item) do
        len = len + 1
    end
    return len
end

local function keys(item)
    if type(item) ~= 'table' then return nil end
    local arr = {}
    for k, _ in pairs(item) do
        arr[#arr+1] = k
    end
    return arr
end

local function iskey(key, item)
    if not key or type(item) ~= 'table' then return false end
    for k, v in pairs(item) do
        if k == key then return {k,v} end
    end
    return false
end

local function isval(val, item)
    if not val or type(item) ~= 'table' then return false end
    for k, v in pairs(item) do
        if v == val then return {k,v} end
    end
    return false
end

local function array(...)
    local args = {...}
    local start, fin, step = 0, args[1] or 0, 1

    if #args>1 and args[2]<0 then start=-1 fin=-args[1] step=args[2] end

    local arr={}
    for i=start, fin, step do arr[i]=0 end
    return arr
end

local function range(...)
    local args = {...}
    local start, fin
    local step = args[3] or 1

    if #args==1 then
        start = 1
        fin = args[1]
    elseif #args>=2 then
        start = args[1]
        fin = args[2]
    else
        return nil
    end

    local arr = {}
    for i=start, fin, step do arr[#arr+1]=i end
    if #arr>0 then return arr else return nil end
end

local function repl(item, num)
    local arr = {}
    for i=1, num do
        arr[i] = item
    end
    return arr
end

local function split(item, sep)
    if (type(item) ~= 'string' and type(item) ~= 'number') then return nil end
    item = tostring(item)
    sep = sep or ''
    local arr = {}

    local function utf8find(str,find)
        for i=1, utf8.len(str) do
            local st=utf8.offset(str,i)
            local fin=utf8.offset(str,i+1)-1
            if str:sub(st, fin) == find then
                return i
            end
        end
    end

    if utf8find(item,sep) ~= nil then
        while utf8find(item,sep)  do
            local ind = utf8find(item,sep)
            local st=utf8.offset(item,ind)
            local fin=utf8.offset(item,ind+1)-1
            arr[#arr+1] = item:sub(1, st-1)
            item = item:sub(fin+1, -1)
        end

        arr[#arr+1] = item:sub(1, item:len())
    else
        for i=1, utf8.len(item) do
            local st=utf8.offset(item,i)
            local fin=utf8.offset(item,i+1)-1
            arr[i] = item:sub(st, fin)
        end
    end
    return arr
end

local function reverse(item)
    if type(item) ~= 'table' then return nil end
    local arr = {}
    local meta = getmetatable(item)
    for k,v in pairs(item) do
        if type(k) == 'number' then
            arr[#item-k+1]=v
        else
            arr[k] = v
        end
    end
    setmetatable(arr, meta)
    return arr
end

local function slice(item, start, fin, step)
    if type(item) ~= 'table' then return nil end
    fin = fin or lent(item)
    step = step or 1
    local arr = {}
    local rang=range(start, fin, step)
    for i=1, #rang do
        local key=keys(item)[rang[i]]
        arr[key]=item[key]
    end
    return arr
end

local function sep(item, num)
    if type(item) ~= 'table' then return nil end
    num = num or 1
    local arr = {}
    for i=1, lent(item), num do
        local tmp_item = slice(item,i,num+i-1)
        if lent(tmp_item) == num then arr[#arr+1] = tmp_item end
    end
    return arr
end

local function clone(item)
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

local function copy(item)
    if type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do arr[k] = v end
    return arr
end

local function iter(item)
    if type(item) ~= 'table' then return nil end
    local tmp_item = clone(item)
    local arr = {}
    local meta = {}

    function meta.__index()
        local all_keys = keys(tmp_item)
        if next(all_keys) then
            local key = all_keys[1]
            local res = tmp_item[key]
            tmp_item[key] = nil
            return res end
    end

    function meta.__len()
    local len = 0
    for _,_ in pairs(tmp_item) do len = len + 1 end
    return len
    end
    setmetatable(arr, meta)
    return arr
end

local function equal(item1, item2)
    if type(item1) ~= 'table' or type(item2) ~= 'table' then return nil end
    local len1 = lent(item1)
    local len2 = lent(item2)
    if len1 ~= len2 then return false end
    for i = 1, len1 do
        if item1[i] ~= item2[i] then return false end
    end
    return true
end

local function join(item1, item2)
    if not item1 then return nil end
    if type(item1) ~= 'table' then item1 = {item1} end
    item2 = item2 or {}
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

local function merge(item1, item2)
    if type(item1) ~= 'table' or type(item2) ~= 'table' then return nil end
    local arr={}
    local keys1=keys(item1)
    local keys2=keys(item2)
    for i=1, #keys1 do
        arr[item1[keys1[i]]]=item2[keys2[i]]
    end
    return arr
end

local function map(func, item)
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        arr[k] = func(v)
    end
    return arr
end

local function mapr(func, item)
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

local function mapx(func, item)
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        arr[k] = function () return func(v) end
    end
    return arr
end

local function exem(item)
    if type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        if type(v) ~= 'function' then arr[k] = v end
        arr[k] = v()
    end
    return arr
end

local function filter(func, item)
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local arr = {}
    for k, v in pairs(item) do
        if func(v) then arr[k] = v end
    end
    return arr
end

local function any(item)
    if type(item) ~= 'table' then return nil end
    for _,v in pairs(item) do if v then return true end end
    return false
end

local function all(item)
    if type(item) ~= 'table' then return nil end
    for _,v in pairs(item) do if not v then return false end end
    return true
end

local function zip(...)
    local args = filter(function(item)
                        if type(item) == 'table' then return true end end,
                        {...})
    if next(args) == nil then return nil end

    local min_len = false
    for _, v in pairs(args) do
        local len_arg
        if getmetatable(v) and getmetatable(v).__len then
            len_arg = #v
        else
            len_arg = lent(v)
        end
        if not min_len then min_len = len_arg end
        if len_arg < min_len then min_len = len_arg end
    end

    local arr = {}
    for i=1, min_len do
        arr[i] = map(function(item) return item[i] end, args)
    end
    return arr
end

local function partial(func, ...)
    if type(func) ~= 'function' then return nil end
    local args = {...}

    local function inner(...)
        local new_args = {...}
        local res = join(args, new_args)

        return func(unpack(res, 1, lent(res)))
    end
    return inner
end

local function reduce(func, item)
    if type(func) ~= 'function' or type(item) ~= 'table' then return nil end
    local res = nil
    local first = item[1]
    local lenght = lent(item)
    if lenght>1 then
        for i = 2, lent(item) do
            res = func(first, item[i])
            first = res
        end
    else
        res = func(first, first)
    end
    return res
end

local function compose(func, wrap)
    if type(func) ~= 'function' then return nil end
    local function inner ( ... )
        return reduce(function(x, y) return  y(x) end, {wrap( ... ), func})
    end
    return inner
end

local function randkey (item)
    if type(item) ~= 'table' then return nil end
    local index = math.random(1, lent(item))
    return keys(item)[index]
end

local function randval(item)
    return item[randkey(item)]
end

local function shuff(item)
    if type(item) ~= 'table' then return nil end
    local arr = {}
    local tmp_item = clone(item)
    for i=1, lent(tmp_item) do
        local index = randkey(tmp_item)
        local key = index
        if type(index) == 'number' then key = i end
        arr[key] = tmp_item[index]
        tmp_item[index] = nil
    end
    return arr
end

local function shuffknuth(item)
    if type(item) ~= 'table' then return nil end
    local arr = clone(item)
    for i = #arr, 1, -1 do
        local index = math.random(#arr)
        arr[i], arr[index] = arr[index], arr[i]
    end
    return arr
end


local function test()
    print('when wrong values', gkv('lua', {42}))

    local target = {0, 1, gkv, 'whoami', ['lua'] = 'moon', ['bit'] = {0, 1}}

    print('gkv')
    gkv(target)

    print('\nlent', lent(target), #target)

    print('\nkeys')
    gkv((keys(target)))

    print('\niskey', iskey('bit', target)~=nil)
    print('\nisval')
    gkv(iskey('lua', target))

    print('\narray')
    local zero_arr = array()
    local pos_arr = array(3)
    local neg_arr = array(3,-1)
    gkv(zero_arr)
    gkv(pos_arr)
    gkv(neg_arr)

    print('\nrange')
    gkv((range(1,5,2)))
    for i=1, #range(3) do
        print('range',i)
    end
    gkv(range(5,1,-1))

    print('\nrepl')
    gkv(repl('lua',4))
    gkv(repl(target,2))

    print('\nsplit')
    gkv(split('code'))
    gkv(split('code lua 42 196', ' '))
    gkv(split(196,''))
    gkv(split('no sense','42'))
    gkv(split('⌘ utf8 й', ' '))
    gkv(split('⌘ utf8 й', ''))
    gkv(split('⌘utf8⌘utf8⌘utf8⌘', '⌘'))

    print('\nreverse')
    gkv(reverse(target))
    print(table.concat(reverse({0,4,2,1})))

    print('\nslice')
    gkv(slice({1,2,3,'lua'},2,4,2))

    gkv(slice(target,2))
    gkv(slice(target,2,#target))

    print('\nsep')
    for _,v in pairs(sep(target,2)) do gkv(v) end

    local a = clone(target)
    local b = clone(target)
    print('\nclone',a ~= b)
    print('deep clone', a['bit'] ~= b['bit'])

    a = copy(target)
    b = copy(target)
    print('\ncopy', a ~= b)
    print('copy first level', a['bit'] ~= b['bit'])

    print('\niter')
    local itarget = iter(target)
    local rep = repl(itarget, 2)
    print('first', itarget[1])
    for i=1, #itarget do
        print(itarget[i])
    end
    print('first from rep1',rep[1][1], 'first from rep2',rep[2][1])

    print('\nequal', equal(a, b))
    local complex_eq = partial(equal, {1,1})
    gkv(map(complex_eq, {{1,0},{0,1},{0,0},{1,1}}))

    print('\njoin')
    print('no args',join())
    gkv(join(target, {'join', zero = 0}))
    print('join tables and values')
    gkv(join({1,0}, 42))
    print('join vargs')
    gkv(reduce(join, {{1,0}, 42, {['lua']=1993}, {196,['code']='lua'}}))

    print('\nmerge')
    local mer_val_val = merge({'lua','code'},array(2))
    gkv(mer_val_val)

    print('\nmap')
    gkv(map(table.concat, {{'map'}, {0,1}}))
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

    local arr = {16, 32, 64, 128}
    local mixarr = {'moon', 'lua', 'code',0, false, nil}
    print('\nfilter')
    print('string only')
    gkv(filter(function(x) return type(x) == 'string' end, mixarr))
    print('> 0')
    gkv(filter(function (x) return x > 32 end, arr))
    print('len > 3')
    gkv(filter(function(x) return tostring(x):len() > 3 end , mixarr))

    print('\nany')
    print(any(arr))
    print(any(mixarr))
    print(not any(map(function(x) return type(x)=='string' end, mixarr)))
    print(any({false,nil}))
    print(any({0,0,0}))

    print('\nall')
    print(all(arr))
    print(all(mixarr))
    print(all(map(function(x) return type(x)=='string' end, mixarr)))
    print(all({false,nil}))
    print(all({0,0,0}))

    print('\nzip')
    local zipped = zip(arr, mixarr)
    map(gkv, zipped)
    print('unzip')
    local unzipped = zip(unpack(zipped))
    map(gkv, unzipped)
    print('only for num keys')
    local key_tab = {['key'] = 'key'}
    local num_tab = {1, 0}
    map(gkv, zip(key_tab, num_tab))
    print('zip like sep')
    local sep_two = zip(unpack(repl(iter(range(6)),2)))
    map(gkv,sep_two)
    print('zip two iter')
    local iter_zip = zip(unpack(repl(iter(target),2)))
    map(gkv,iter_zip)

    -- print('\nreduce')
    -- local nested = {{1,0},{0,1},{0,0},1,1,{42,42}}
    -- print(reduce(function(x, y) return  x + y end, {1,2,4,8,16,32,64,128}))
    -- print('flat table')
    -- gkv(reduce(join,nested))

    -- print('\npartial')
    -- print('make print # function')
    -- local print_she = partial(print, '#')
    -- print_she('whoami','code')
    -- print('make map to string function')
    -- local mapstr = partial(map, tostring)
    -- gkv(mapstr(arr))
    -- print('make filter for numbers')
    -- local filter_str = partial(filter,
    --                            function(x) return type(x) == 'number' end)
    -- gkv(filter_str(mixarr))

    -- print('\ncompose')
    -- print('make lent for all items')
    -- local maplent = partial(map, string.len)
    -- print('exclude gkv')
    -- local no_gkv = compose(gkv, mapstr)
    -- no_gkv(mixarr)
    -- print('exclude lent')
    -- local no_lent = compose(maplent, compose(mapstr, filter_str))
    -- gkv(no_lent(mixarr))

    -- print('\nrandkey', target[randkey(target)])
    -- print('\nrandval', randval(target))
    -- print('randval 100', randval(range(100)))
    -- local rand100 = {}
    -- for _=1, 10 do table.insert(rand100,randval(range(10))) end
    -- print('randval table 10', gkv(rand100))

    -- print('\nshuff')
    -- local shuffle_tar=shuff(target)
    -- gkv(shuffle_tar)
    -- gkv(target)

    -- print('\nshuffknuth')
    -- local shuffle_k = shuffknuth(target)
    -- gkv(shuffle_k)
    -- gkv(target)
end

-- test()

return { ['gkv'] = gkv, ['lent'] = lent, ['keys'] = keys,['iskey'] = iskey,
        ['isval'] = isval, ['array'] = array, ['range'] = range,
        ['repl'] = repl, ['split'] = split, ['reverse'] = reverse,
        ['slice']=slice, ['sep']=sep, ['clone'] = clone, ['copy'] = copy,
        ['iter'] = iter, ['equal'] = equal, ['join'] = join,['merge'] = merge,
        ['map'] = map, ['mapx'] = mapx, ['exem'] = exem, ['mapr'] = mapr,
        ['filter'] = filter, ['any'] = any, ['all'] = all, ['zip'] = zip,
        ['reduce'] = reduce, ['partial'] = partial, ['compose'] = compose,
        ['randkey'] = randkey, ['randval'] = randval, ['shuff'] = shuff,
        ['shuffknuth'] = shuffknuth,
        ['test'] = test}
