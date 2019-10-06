#!/usr/bin/env lua
-- Mon Jun  4 17:45:53 2018
-- (c) Alexander Veledzimovich
-- test FCT

-- lua<5.3
local utf8 = require('utf8')
local unpack = table.unpack or unpack

local fc=require('fct')

local function gkv(...)
    for _,value in pairs(...) do
        if type(value) == 'table' then
            for k, v in pairs(value) do print(k, v, type(v)) end
        else
            print(value)
        end
    end
end

local function test()
    local target = {0, 1,gkv,'whoami',['lua'] = 'moon',['bit'] = {0, 1}}
    print('gkv')
    gkv(target)

    print('\nlent', fc.len(target), #target)

    print('\ncount', fc.count(0,target))

    print('\nkeys')
    gkv((fc.keys(target)))

    print('\nvals')
    gkv((fc.vals(target)))

    print('\niskey', fc.iskey('bit', target)~=nil)
    print('\nisval')
    gkv(fc.iskey('lua', target))

    print('\nflip')
    local days = {'Sunday', 'Monday', 'Tuesday', 'Wednesday',
                      'Thursday', 'Friday', 'Saturday'}
    local revdays = fc.flip(days)
    gkv(revdays)
    print(fc.isval('Sunday',days)[1])

    print('\nrange')
    gkv(fc.range())

    gkv(fc.range(1,5,2))
    gkv(fc.range(3,1,-1))
    for i=1, #fc.range(3) do
        print('range',i)
    end

    print('\nrep')
    gkv(fc.rep('lua',4))
    print('randtab')
    gkv(fc.rep(math.random(),4))
    print('matrix')
    local matrix = {}
    for i=1,2 do matrix[i]=fc.rep(0,8) end
    print(table.concat(matrix[1],' '),table.concat(matrix[2],' '))

    print('\nsplit')
    gkv(fc.split('code'))
    gkv(fc.split('code lua 42 196', ' '))
    gkv(fc.split(196,''))
    gkv(fc.split('no sense','42'))
    gkv(fc.split('⌘ utf8 й', ' '))
    gkv(fc.split('⌘ utf8 й', ''))
    gkv(fc.split('⌘utf8⌘utf8⌘utf8⌘', '⌘'))

    print('\nreverse')
    gkv(fc.reverse(target))
    print(fc.reverse(target)[2])

    print('\nisort')
    local code={['lua']=1993,['c']=1970,['swift']=2013}
    for k,v in fc.isort(code,nil,true) do
        print(k,v)
    end

    print('\nslice')
    gkv(fc.slice({1,2,3,'lua'},2,4,2))
    gkv(fc.slice(target,2))
    gkv(fc.slice(target,2,#target))
    gkv(fc.slice(target,4,fc.len(target)))

    print('\nsep')
    fc.map(gkv,fc.sep(target,2))

    local a = fc.copy(target)
    local b = fc.copy(target)
    print('\ncopy',a ~= b)
    print('deep copy', a['bit'] ~= b['bit'])
    print('meta copy')
    local tab1 = {42,['code']={}}
    local meta1=setmetatable(tab1, {__index=tab1, __len = function (self)
                                    return fc.len(self) end})
    local copymeta=fc.copy(meta1)
    print('meta copy false',copymeta==meta1)
    print('meta tables false', getmetatable(copymeta)==getmetatable(meta1))
    print('use meta method',#copymeta,#meta1)
    getmetatable(copymeta).__len=nil
    print('use meta method',#copymeta,#meta1)
    print('meta1 still have function', getmetatable(meta1).__len)
    print('meta1[1] copymeta[1]', meta1[1],copymeta[1])
    print('meta1[2]==copymeta[2]', meta1['code']==copymeta['code'])

    print('\niter')
    local itarget = fc.iter(tab1)
    local rep = fc.rep(itarget, 2)
    print('first', itarget[1])
    print('never use fc.len() with iter')
    print('iter.__index use together keys and index')
    for i=1, #rep[1] do
        print(rep[1][i])
    end
    print('first from rep1',rep[1][1], 'first from rep2',rep[2][1])

    print('\nequal', fc.equal(a, b))
    print(fc.equal(target,target))
    local eqtab = fc.partial(fc.equal, {1,1})
    gkv(fc.map(eqtab, {{1,0},{0,1},{0,0},{1,1}}))

    print('\njoin')
    print('no fargs',fc.join())
    gkv(fc.join(target, {'join', zero = 0}))
    print('join tables and values')
    gkv(fc.join({1,0}, 42))
    print('join fargs')
    gkv(fc.reduce(fc.join, {{1,0},42,{['lua']=1993},{196,['code']='lua'}}))
    print('join with metatable')
    local tab2 = {42,['code']={'lua',1993}}
    setmetatable(tab2, {__index=tab2,__tostring=function(_)
                                            return 'meta2' end})

    local metajoin=fc.join(0, tab2)
    print(metajoin,'metajoin.code==tab2.code', metajoin.code==tab2.code)

    print('\nunion')
    gkv(fc.union(target,{0,1,42}))

    print('\nsame')
    gkv(fc.same(target,{0,1,42}))

    print('\ndiff')
    gkv(fc.diff(target,{0,1,42}))


    print('\nmap')
    gkv(fc.map(table.concat, {{'map'}, {0,1}}))
    gkv(fc.map(tostring, fc.range(1,3)))
    print('len all items')
    gkv(fc.map(string.len, fc.map(tostring, target)))
    print('print values')
    fc.map(print, target)

    print('\nmapr')
    local recursive = fc.mapr(tostring, target)
    gkv(recursive)
    print('string in table')
    gkv(recursive['bit'])
    print('print all items recursevly')
    fc.mapr(print, target)
    print('len all items recursevly')
    local maprlen = fc.mapr(string.len,recursive)
    gkv(fc.join(maprlen,maprlen['bit']))
    print('use mapr for varg with zip like in python map')
    fc.mapr(print,{unpack(fc.zip(target,{1,42,196}))})
    print('use straight')
    fc.mapr(print,{target,{0,1},'whoami',{code='lua'}})

    local array = {16, 32, 64, 128}
    local mixarr = {'moon', 'lua', 'code',0, false, nil}
    print('\nfilter')
    print('string only')
    gkv(fc.filter(function(x) return type(x) == 'string' end, mixarr))
    print('> 32')
    gkv(fc.filter(function (x) return x>32 end, array))
    print('len > 3')
    gkv(fc.filter(function(x) return tostring(x):len()>3 end , mixarr))

    print('\nany')
    print(fc.any(array))
    print(fc.any(mixarr))
    print(not fc.any(fc.map(function(x)
                            return type(x)=='string' end, mixarr)))
    print(fc.any({false,nil}))
    print(fc.any({0,0,0}))

    print('\nall')
    print(fc.all(array))
    print(fc.all(mixarr))
    print(fc.all(fc.map(function(x) return type(x)=='string' end, mixarr)))
    print(fc.all({false,nil}))
    print(fc.all({0,0,0}))

    print('\nzip')
    local zipped = fc.zip(array, mixarr)
    fc.map(gkv, zipped)
    print('unzip')
    local unzipped = fc.zip(unpack(zipped))
    fc.map(gkv, unzipped)
    print('only for num keys')
    local keytab = {['key'] = 'key'}
    local numtab = {1, 0}
    fc.map(gkv, fc.zip(keytab, numtab))
    print('zip like sep')
    local septwo = fc.zip(unpack(fc.rep(fc.iter(fc.range(6)),2)))
    fc.map(gkv,septwo)
    print('zip two iter')
    local iterzip = fc.zip(unpack(fc.rep(fc.iter(target),2)))
    fc.map(gkv,iterzip)

    print('\nreduce')
    print(fc.reduce(function(x,y) return x*y end, {1}))
    local nested = {{1,0},{0,1},{0,0},1,1,{42,42}}
    print(fc.reduce(function(x, y) return  x+y end, {1,2,4,8,16,32,64,128}))
    print('flat table')
    gkv(fc.reduce(fc.join,nested))

    print('\npartial')
    print('make print # function')
    local printshe = fc.partial(print, '#')
    printshe('whoami','code')
    print('make map to string function')
    local mapstr = fc.partial(fc.map, tostring)
    gkv(mapstr(array))
    print('make filter for numbers')
    local filstr = fc.partial(fc.filter,
                               function(x) return type(x)=='number' end)
    gkv(filstr(mixarr))

    print('\ncompose')
    print('exclude gkv')
    local nogkv = fc.compose(gkv, mapstr)
    nogkv(mixarr)
    print('make lent for all items')
    local maplent = fc.partial(fc.map, string.len)
    print('exclude lent')
    local nolent = fc.compose(maplent, fc.compose(mapstr, filstr))
    gkv(nolent(mixarr))

    print('\naccumulate')
    print(unpack(fc.accumulate(fc.range(5))))
    print(unpack(fc.accumulate(fc.range(5),function(aa,bb) return aa*bb end)))


    print('\npermutation')
    local mut=fc.permutation(fc.range(3))
    fc.map(function(x) print(table.concat(x,' ')) end, mut)
    mut=fc.permutation({'a','b','c'})
    fc.map(function(x) print(table.concat(x,' ')) end, mut)

    print('\ncombinations')
    local combi = fc.combination({0,1,2,3},3)
    print('combinations', #combi)
    fc.map(function(x) print (table.concat(x, ' ')) end, combi)

    local clr=fc.combination(fc.range(0,1,0.1),3)
    fc.map(function(x) print(table.concat(x,' ')) end, clr)

    print('\nrandkey', target[fc.randkey(target)])
    print('\nrandval', fc.randval(target))
    print('randval 100', fc.randval(fc.range(100)))

    print('\nshuff')
    local shuf = fc.shuff(target)
    print('target')
    gkv(target)
    print('shuf')
    gkv(shuf)

    print('\nshuffknuth')
    gkv(fc.shuffknuth(fc.range(5)),' ')

    local shufk = fc.shuffknuth(target)
    print('target')
    gkv(target)
    print('shufk')
    gkv(shufk)

    print('shuffknuth perfomance')
    local tclk = os.clock()
    local str= 'Hello W'
    local hell=fc.split(str)

    for _=1, math.huge do
        hell=fc.shuffknuth(hell)
        if table.concat(hell)==str then break end
    end
    print(os.clock()-tclk)
    print(table.concat(hell))
end

test()
