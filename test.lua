#!/usr/bin/env lua
-- Mon Jun  4 17:45:53 2018
-- (c) Alexander Veledzimovich
-- test FUN

local fc=require('fun')
-- old lua version
local unpack = table.unpack or unpack

local function test()
    local target = {0, 1,fc.gkv,'whoami',['lua'] = 'moon',['bit'] = {0, 1}}
    print('gkv')
    fc.gkv(target)

    print('\nlent', fc.lent(target), #target)

    print('\ncount', fc.count(0,target))

    print('\nkeys')
    fc.gkv((fc.keys(target)))

    print('\niskey', fc.iskey('bit', target)~=nil)
    print('\nisval')
    fc.gkv(fc.iskey('lua', target))

    print('\narray')
    local zero_arr = fc.array()
    local pos_arr = fc.array(3)
    local neg_arr = fc.array(3,-1)
    fc.gkv(zero_arr)
    fc.gkv(pos_arr)
    fc.gkv(neg_arr)

    print('\nrange')
    fc.gkv((fc.range(1,5,2)))
    for i=1, #fc.range(3) do
        print('range',i)
    end
    fc.gkv(fc.range(5,1,-1))

    print('\nrepl')
    fc.gkv(fc.repl('lua',4))
    fc.gkv(fc.repl(target,2))

    print('\nsplit')
    fc.gkv(fc.split('code'))
    fc.gkv(fc.split('code lua 42 196', ' '))
    fc.gkv(fc.split(196,''))
    fc.gkv(fc.split('no sense','42'))
    fc.gkv(fc.split('⌘ utf8 й', ' '))
    fc.gkv(fc.split('⌘ utf8 й', ''))
    fc.gkv(fc.split('⌘utf8⌘utf8⌘utf8⌘', '⌘'))

    print('\nreverse')
    fc.gkv(fc.reverse(target))
    print(table.concat(fc.reverse({0,4,2,1})))

    print('\nslice')
    fc.gkv(fc.slice({1,2,3,'lua'},2,4,2))
    fc.gkv(fc.slice(target,2))
    fc.gkv(fc.slice(target,2,#target))

    print('\nsep')
    for _,v in pairs(fc.sep(target,2)) do fc.gkv(v) end

    a = fc.copy(target)
    b = fc.copy(target)
    print('\ncopy', a ~= b)
    print('copy first level', a['bit'] ~= b['bit'])

    local a = fc.clone(target)
    local b = fc.clone(target)
    print('\nclone',a ~= b)
    print('deep clone', a['bit'] ~= b['bit'])

    print('meta clone')
    local tab1 = {42,['code']={}}
    local meta1=setmetatable(tab1, {__index=tab1, __len = function (self)
                                    return fc.lent(self) end})
    local clone_meta=fc.clone(meta1)
    print('meta clone false',clone_meta==meta1)
    print('meta tables false', getmetatable(clone_meta)==getmetatable(meta1))
    print('use meta method',#clone_meta,#meta1)
    getmetatable(clone_meta).__len=nil
    print('use meta method',#clone_meta,#meta1)
    print('meta1 still have function', getmetatable(meta1).__len)
    print('meta1[1] clone_meta[1]', meta1[1],clone_meta[1])
    print('meta1[2]==clone_meta[2]', meta1['code']==clone_meta['code'])

    print('\niter')
    local itarget = fc.iter(target)
    local rep = fc.repl(itarget, 2)
    print('first', itarget[1])
    for i=1, #itarget do
        print(itarget[i])
    end
    print('first from rep1',rep[1][1], 'first from rep2',rep[2][1])

    print('\nequal', fc.equal(a, b))
    print(fc.equal(target,target))
    local complex_eq = fc.partial(fc.equal, {1,1})
    fc.gkv(fc.map(complex_eq, {{1,0},{0,1},{0,0},{1,1}}))

    print('\njoin')
    print('no fargs',fc.join())
    fc.gkv(fc.join(target, {'join', zero = 0}))
    print('join tables and values')
    fc.gkv(fc.join({1,0}, 42))
    print('join fargs')
    fc.gkv(fc.reduce(fc.join, {{1,0},42,{['lua']=1993},{196,['code']='lua'}}))
    print('join metatable')
    local tab2 = {42,['code']={'lua',1993}}
    setmetatable(tab2, {__index=tab2,__tostring=function(self)
                                            return 'meta2' end})
    print('join with metatable')
    local meta_join=fc.join(0, tab2)
    print(meta_join, meta_join.code==tab2.code)

    print('\nvalval')
    local mer_val_val = fc.valval({'lua','code'},fc.array(2))
    fc.gkv(mer_val_val)

    print('\nmerge')
    fc.gkv(fc.merge(target,{0,1,42}))

    print('\nsame')
    fc.gkv(fc.same(target,{0,1,42}))

    print('\nuniq')
    fc.gkv(fc.uniq(target,{0,1,42}))

    print('\nmap')
    fc.gkv(fc.map(table.concat, {{'map'}, {0,1}}))
    fc.gkv(fc.map(tostring, fc.range(1,3)))
    print('len all items')
    fc.gkv(fc.map(string.len, fc.map(tostring, target)))
    print('print values')
    fc.map(print, target)

    print('\nmapx')
    local python3_map = fc.mapx(tostring, target)
    fc.gkv(python3_map)
    print('\nexem')
    fc.gkv(fc.exem(fc.mapx(string.len, fc.exem(python3_map))))

    print('\nmapr')
    local recursive = fc.mapr(tostring, target)
    fc.gkv(recursive)
    print('string in table')
    fc.gkv(recursive['bit'])
    print('print all items recursevly')
    fc.mapr(print, target)
    print('len all items recursevly')
    fc.gkv(fc.map(string.len,
                  fc.map(tostring,fc.join(recursive, recursive['bit']))))

    local arr = {16, 32, 64, 128}
    local mixarr = {'moon', 'lua', 'code',0, false, nil}
    print('\nfilter')
    print('string only')
    fc.gkv(fc.filter(function(x) return type(x) == 'string' end, mixarr))
    print('> 0')
    fc.gkv(fc.filter(function (x) return x > 32 end, arr))
    print('len > 3')
    fc.gkv(fc.filter(function(x) return tostring(x):len() > 3 end , mixarr))

    print('\nany')
    print(fc.any(arr))
    print(fc.any(mixarr))
    print(not fc.any(fc.map(function(x)
                            return type(x)=='string' end, mixarr)))
    print(fc.any({false,nil}))
    print(fc.any({0,0,0}))

    print('\nall')
    print(fc.all(arr))
    print(fc.all(mixarr))
    print(fc.all(fc.map(function(x) return type(x)=='string' end, mixarr)))
    print(fc.all({false,nil}))
    print(fc.all({0,0,0}))

    print('\nzip')
    local zipped = fc.zip(arr, mixarr)
    fc.map(fc.gkv, zipped)
    print('unzip')
    local unzipped = fc.zip(unpack(zipped))
    fc.map(fc.gkv, unzipped)
    print('only for num keys')
    local key_tab = {['key'] = 'key'}
    local num_tab = {1, 0}
    fc.map(fc.gkv, fc.zip(key_tab, num_tab))
    print('zip like sep')
    local sep_two = fc.zip(unpack(fc.repl(fc.iter(fc.range(6)),2)))
    fc.map(fc.gkv,sep_two)
    print('zip two iter')
    local iter_zip = fc.zip(unpack(fc.repl(fc.iter(target),2)))
    fc.map(fc.gkv,iter_zip)

    print('\nreduce')
    local nested = {{1,0},{0,1},{0,0},1,1,{42,42}}
    print(fc.reduce(function(x, y) return  x + y end, {1,2,4,8,16,32,64,128}))
    print('flat table')
    fc.gkv(fc.reduce(fc.join,nested))

    print('\npartial')
    print('make print # function')
    local print_she = fc.partial(print, '#')
    print_she('whoami','code')
    print('make map to string function')
    local mapstr = fc.partial(fc.map, tostring)
    fc.gkv(mapstr(arr))
    print('make filter for numbers')
    local filter_str = fc.partial(fc.filter,
                               function(x) return type(x) == 'number' end)
    fc.gkv(filter_str(mixarr))

    print('\ncompose')
    print('make lent for all items')
    local maplent = fc.partial(fc.map, string.len)
    print('exclude gkv')
    local no_gkv = fc.compose(fc.gkv, mapstr)
    no_gkv(mixarr)
    print('exclude lent')
    local no_lent = fc.compose(maplent, fc.compose(mapstr, filter_str))
    fc.gkv(no_lent(mixarr))

    print('\nrandkey', target[fc.randkey(target)])
    print('\nrandval', fc.randval(target))
    print('randval 100', fc.randval(fc.range(100)))
    local rand100 = {}
    for _=1, 10 do table.insert(rand100,fc.randval(fc.range(10))) end
    print('randval table 10', fc.gkv(rand100))

    print('\nshuff')
    local shuffle_tar = fc.shuff(target)
    fc.gkv(shuffle_tar)
    fc.gkv(target)

    print('\nshuffknuth')
    local shuffle_k = fc.shuffknuth(target)
    fc.gkv(shuffle_k)
    fc.gkv(target)

    print('error when wrong values')
    -- fc.gkv('lua')
end

test()
