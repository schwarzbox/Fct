#!/usr/bin/env lua
-- FCT
-- 2.5
-- Functional Tools (lua)
-- fct.lua

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

-- 3.0
-- map yield
-- 4.0
-- clear tests

-- Tool Box
-- gkv, lent, count, keys, vals, iskey, isval, ztab, range, repl,
-- cut, reverse, isort, slice, sep, copy, clone, iter,
-- equal, join, valval, merge, same, uniq,
-- map, mapr, filter, any, all, zip, partial, reduce, compose,
-- randtab, randkey, randval, shuff, shuffknuth

-- No metatables when return arr
-- keys, vals, ztab, range, repl, cut, sep, copy, iter, valval, merge, same, uniq, zip, randtab

-- Error traceback
-- nofarg, numfarg

if arg[0] then print('2.5 FCT Functional Tools (lua)', arg[0]) end
if arg[1] then print('2.5 FCT Functional Tools (lua)', arg[1]) end

-- old lua version
local unpack = table.unpack or unpack
local utf8 = require('utf8')
-- seed
math.randomseed(os.time())
-- errors
local function numfarg(name)
    local k,_
    for i=1,16 do k,_ = debug.getlocal(3,i) if k==name then return i end end
end

local function nofarg(farg,name,expected)
    if type(farg)~=expected then
        local t1,t2,num,fin
        num = numfarg(name)
        t1=string.format('%s: %s: bad argument #%d to', arg[-1], arg[0],num)
        t2=string.format('(expected %s, got %s)', expected, type(farg))
        fin=string.format('%s \'%s\' %s', t1, debug.getinfo(2)['name'], t2)
        print(debug.traceback(fin,2))
        os.exit(1)
    end
end

local FCT={}
function FCT.gkv(item)
    nofarg(item,'item','table')
    for k, v in pairs(item) do print(k, v, type(v)) end
end

function FCT.lent(item)
    nofarg(item,'item','table')
    local len = 0
    for _ in pairs(item) do len = len + 1 end
    return len
end

function FCT.count(val, item)
    nofarg(item,'item','table')
    local res = 0
    for _,v in pairs(item) do
        if v==val then res = res + 1 end
    end
    return res
end

function FCT.keys(item)
    nofarg(item,'item','table')
    local arr = {}
    for k, _ in pairs(item) do
        arr[#arr+1] = k
    end
    return arr
end

function FCT.vals(item)
    nofarg(item,'item','table')
    local arr = {}
    for _, v in pairs(item) do
        arr[#arr+1] = v
    end
    return arr
end

function FCT.iskey(key, item)
    nofarg(item,'item','table')
    if key==nil then return false end
    for k, v in pairs(item) do
        if k==key then return {k,v} end
    end
    return false
end

function FCT.isval(val, item)
    nofarg(item,'item','table')
    if val==nil then return false end
    for k, v in pairs(item) do
        if v==val then return {k,v} end
    end
    return false
end

function FCT.ztab(num)
    local start, fin = 1, num or 1
    local arr = {}
    for i=start, math.abs(fin) do arr[i] = 0 end
    return arr
end

function FCT.range(...)
    local fargs = {...}
    local start, fin
    local step = fargs[3] or 1

    local arr = {}
    if #fargs==1 then
        start, fin = 1, fargs[1]
    elseif #fargs>=2 then
        start, fin = fargs[1], fargs[2]
    else
        return arr
    end

    for i=start, fin, step do arr[#arr+1] = i end
    return arr
end

function FCT.repl(obj, num)
    nofarg(num,'num','number')
    local arr = {}
    for i=1, num do arr[i] = obj end
    return arr
end

function FCT.cut(obj, sep)
    if type(obj)=='number' then obj = tostring(obj) end
    nofarg(obj,'obj','string')
    sep = sep or ''
    local arr = {}

    local function utf8find(str,find)
        for i=1, utf8.len(str) do
            local st = utf8.offset(str,i)
            local fin = utf8.offset(str,i+1)-1
            if str:sub(st, fin)==find then
                return i
            end
        end
    end

    if utf8find(obj,sep)~=nil then
        while utf8find(obj,sep)  do
            local ind = utf8find(obj,sep)
            local st = utf8.offset(obj,ind)
            local fin = utf8.offset(obj,ind+1)-1
            arr[#arr+1] = obj:sub(1, st-1)
            obj = obj:sub(fin+1, -1)
        end

        arr[#arr+1] = obj:sub(1, obj:len())
    else
        for i=1, utf8.len(obj) do
            local st = utf8.offset(obj,i)
            local fin = utf8.offset(obj,i+1)-1
            arr[i] = obj:sub(st, fin)
        end
    end
    return arr
end

function FCT.reverse(item)
    nofarg(item,'item','table')
    local arr = {}
    local meta = getmetatable(item)
    for k,v in pairs(item) do
        if type(k)=='number' then
            arr[#item-k+1] = v
        else
            arr[k] = v
        end
    end
    setmetatable(arr, meta)
    return arr
end

function FCT.isort(item,values,reverse)
    nofarg(item,'item','table')
    local keys = {}
    for k,_ in pairs(item) do keys[#keys+1]=k end

    if values then
        local sort = function(t,a,b) return t[a]<t[b] end
        if reverse then
            sort = function(t,a,b) return t[a]>t[b] end
        end

        table.sort(keys,function(a,b) return sort(item,a,b) end)
    else
        table.sort(keys)
        if reverse then
            table.sort(keys,function(a,b) return a>b end)
        end
    end

    local i = 0
    local function inner()
        i = i+1
        if keys[i] then return keys[i], item[keys[i]] end
    end
    return inner
end

function FCT.slice(item,start,fin,step)
    nofarg(item,'item','table')
    start = start or 1
    if not fin or fin>FCT.lent(item) then fin = FCT.lent(item) end
    step = step or 1
    local arr = {}
    local meta = getmetatable(item)
    local keys = FCT.keys(item)
    for i=start, fin, step do
        local k = keys[i]
        if type(k)=='number' then k = #arr+1 end
        arr[k] = item[keys[i]]
    end
    setmetatable(arr, meta)
    return arr
end

function FCT.sep(item,num)
    nofarg(item,'item','table')
    num = num or 1
    local arr = {}
    for i=1, FCT.lent(item), num do
        local tmp_item = FCT.slice(item,i,num+i-1)
        FCT.lent(tmp_item)
        if FCT.lent(tmp_item) == num then arr[#arr+1] = tmp_item end
    end
    return arr
end

function FCT.copy(item)
    nofarg(item,'item','table')
    local arr = {}
    for k, v in pairs(item) do arr[k] = v end
    return arr
end

function FCT.clone(item)
    nofarg(item,'item','table')
    local arr = {}
    local meta = FCT.copy(getmetatable(item) or {})

    for k, v in pairs(item) do
        if type(v) == 'table' then
            arr[k] = FCT.clone(v)
        else
            arr[k] = v
        end
    end
    setmetatable(arr, meta)
    return arr
end

function FCT.iter(item)
    nofarg(item,'item','table')
    local tmp_item = FCT.clone(item)
    local arr = {}
    local meta = {}

    function meta.__index()
        local all_keys = FCT.keys(tmp_item)
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

function FCT.equal(item1,item2)
    nofarg(item1,'item1','table')
    nofarg(item2,'item2','table')
    local len1 = FCT.lent(item1)
    local len2 = FCT.lent(item2)
    if len1~=len2 then return false end
    for k,v in pairs(item1) do
        if v~=item2[k] then return false end
    end
    return true
end

function FCT.join(item1,item2)
    if type(item1)~='table' then item1 = {item1} end
    item2 = item2 or {}
    if type(item2)~='table' then item2 = {item2} end

    local arr = FCT.clone(item1)

    for k, v in pairs(getmetatable(item2) or {}) do
        getmetatable(arr)[k] = v
    end

    for k, v in pairs(item2) do
        if type(k)=='number' then k = #arr+1 end
        if type(v) == 'table' then arr[k] = FCT.clone(v)
        else arr[k] = v end
    end
    return arr
end

function FCT.valval(item1,item2)
    nofarg(item1,'item1','table')
    nofarg(item2,'item2','table')
    local arr, keys1, keys2 = {}, FCT.keys(item1), FCT.keys(item2)

    for i=1, #keys1 do
        arr[item1[keys1[i]]] = item2[keys2[i]]
    end
    return arr
end

function FCT.merge(item1,item2)
    nofarg(item1,'item1','table')
    nofarg(item2,'item2','table')
    local arr = {}

    for k, v in pairs(item1) do
        if not FCT.isval(v,arr)  then
            if type(k)=='number' then k = #arr+1  end
            arr[k] = v
        end
    end
    for k, v in pairs(item2) do
        if not FCT.isval(v,arr) then
            if type(k)=='number' then k = #arr+1 end
            arr[k] = v
        end
    end
    return arr
end

function FCT.same(item1,item2)
    nofarg(item1,'item1','table')
    nofarg(item2,'item2','table')
    local arr = {}

    for k, v in pairs(item1) do
        if FCT.isval(v,item2) and not FCT.isval(v,arr) then
            if type(k)=='number' then k = #arr+1 end
            arr[k] = v
        end
    end
    return arr
end

function FCT.uniq(item1,item2)
    nofarg(item1,'item1','table')
    nofarg(item2,'item2','table')
    local arr = {}

    for k, v in pairs(item1) do
        if not FCT.isval(v,item2) and not FCT.isval(v,arr) then
            if type(k)=='number' then k = #arr+1 end
            arr[k] = v
        end
    end
    for k, v in pairs(item2) do
        if not FCT.isval(v,item1) and not FCT.isval(v,arr) then
            if type(k)=='number' then k = #arr+1 end
            arr[k] = v
        end
    end
    return arr
end

function FCT.map(func,item)
    nofarg(func,'func','function')
    nofarg(item,'item','table')
    local arr = {}
    local meta = getmetatable(item)

    for k, v in pairs(item) do
        arr[k] = func(v)
    end
    setmetatable(arr,meta)
    return arr
end

function FCT.mapr(func,item)
    nofarg(func,'func','function')
    nofarg(item,'item','table')
    local arr = {}
    local meta = getmetatable(item)
    for k, v in pairs(item) do
        if type(v)=='table' then
            arr[k] = FCT.mapr(func, v)
        else
            arr[k] = func(v)
        end
    end
    setmetatable(arr,meta)
    return arr
end

function FCT.filter(func,item)
    nofarg(func,'func','function')
    nofarg(item,'item','table')
    local arr = {}
    local meta = getmetatable(item)
    for _, v in pairs(item) do
        if func(v) then arr[#arr+1] = v end
    end
    setmetatable(arr,meta)
    return arr
end

function FCT.any(item)
    nofarg(item,'item','table')
    for _,v in pairs(item) do if v then return true end end
    return false
end

function FCT.all(item)
    nofarg(item,'item','table')
    for _,v in pairs(item) do if not v then return false end end
    return true
end

function FCT.zip(...)
    local fargs = FCT.filter(function(item)
                    if type(item)=='table' then return true end end, {...})
    nofarg(fargs[1],'fargs','table')

    local min_len = false
    for _, v in pairs(fargs) do
        local len_arg
        if getmetatable(v) and getmetatable(v).__len then
            len_arg = #v
        else
            len_arg = FCT.lent(v)
        end
        if not min_len then min_len = len_arg end
        if len_arg < min_len then min_len = len_arg end
    end

    local arr = {}
    for i=1, min_len do
        arr[i] = FCT.map(function(item) return item[i] end, fargs)
    end
    return arr
end

function FCT.partial(func,...)
    nofarg(func,'func','function')
    local fargs = {...}

    local function inner(...)
        local new_fargs = {...}
        local res = FCT.join(fargs, new_fargs)

        return func(unpack(res, 1, FCT.lent(res)))
    end
    return inner
end

function FCT.reduce(func,item)
    nofarg(func,'func','function')
    nofarg(item,'item','table')
    local res = nil
    local all_keys = FCT.keys(item)
    local first = item[all_keys[1]]
    local lenght = FCT.lent(item)
    if lenght>1 then
        for i=2, FCT.lent(item) do
            res = func(first, item[all_keys[i]])
            first = res
        end
    else
        res = func(first, first)
    end
    return res
end

function FCT.compose(func,wrap)
    nofarg(func,'func','function')
    nofarg(wrap,'wrap','function')
    local function inner(...)
        return FCT.reduce(function(x, y) return  y(x) end, {wrap(...), func})
    end
    return inner
end

function FCT.randtab(fin,one)
    fin = fin or 1
    local arr = {}
    for i=1, fin do
        if one then arr[i] = math.random()
        else arr[i] = math.random(fin) end
    end
    return arr
end

function FCT.randkey(item)
    nofarg(item,'item','table')
    local index = math.random(1, FCT.lent(item))
    return FCT.keys(item)[index]
end

function FCT.randval(item)
    return item[FCT.randkey(item)]
end

function FCT.shuff(item)
    nofarg(item,'item','table')
    local arr = {}
    local tmp_item = FCT.clone(item)
    for i=1, FCT.lent(tmp_item) do
        local index = FCT.randkey(tmp_item)
        local key = index
        if type(index)=='number' then key = i end
        arr[key] = tmp_item[index]
        tmp_item[index] = nil
    end
    return arr
end

function FCT.shuffknuth(item)
    nofarg(item,'item','table')
    local arr = FCT.clone(item)
    for i=#arr, 1, -1 do
        local index = math.random(#arr)
        arr[i], arr[index] = arr[index], arr[i]
    end
    return arr
end

return FCT
