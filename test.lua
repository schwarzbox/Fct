#!/usr/bin/env lua
-- Mon Jun  4 17:45:53 2018
-- (c) Alexander Veledzimovich
-- test FCT

local fc=require('fct')
-- old lua version
local unpack = table.unpack or unpack

local function test()
    local target = {0, 1,fc.gkv,'whoami',['lua'] = 'moon',['bit'] = {0, 1}}
    print('gkv')
    fc.gkv(target)

    print('\nlent', fc.len(target), #target)

    print('\ncount', fc.count(0,target))

    print('\nkeys')
    fc.gkv((fc.keys(target)))

    print('\nvals')
    fc.gkv((fc.vals(target)))

    print('\niskey', fc.iskey('bit', target)~=nil)
    print('\nisval')
    fc.gkv(fc.iskey('lua', target))

    print('\nflip')
    local days = {'Sunday', 'Monday', 'Tuesday', 'Wednesday',
                      'Thursday', 'Friday', 'Saturday'}
    local revdays = fc.flip(days)
    fc.gkv(revdays)
    print(fc.isval('Sunday',days)[1])

    print('\nrange')
    fc.gkv(fc.range())

    fc.gkv(fc.range(1,5,2))
    fc.gkv(fc.range(3,1,-1))
    for i=1, #fc.range(3) do
        print('range',i)
    end

    print('\nrep')
    fc.gkv(fc.rep('lua',4))
    fc.gkv(fc.rep(target,2))
    print('randtab')
    fc.gkv(fc.rep(math.random(),4))
    print('matrix')
    local matrix = {}
    for i=1,2 do matrix[i]=fc.rep(0,8) end
    print(table.concat(matrix[1],' '),table.concat(matrix[2],' '))

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
    print(fc.reverse(target)[2])

    print('\nisort')
    local code={['lua']=1993,['c']=1970,['swift']=2013}
    for k,v in fc.isort(code,nil,true) do
        print(k,v)
    end

    print('\nslice')
    fc.gkv(fc.slice({1,2,3,'lua'},2,4,2))
    fc.gkv(fc.slice(target,2))
    fc.gkv(fc.slice(target,2,#target))
    fc.gkv(fc.slice(target,4,fc.len(target)))

    print('\nsep')
    fc.map(fc.gkv,fc.sep(target,2))

    local a = fc.clone(target)
    local b = fc.clone(target)
    print('\nclone',a ~= b)
    print('deep clone', a['bit'] ~= b['bit'])
    print('meta clone')
    local tab1 = {42,['code']={}}
    local meta1=setmetatable(tab1, {__index=tab1, __len = function (self)
                                    return fc.len(self) end})
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
    local itarget = fc.iter(tab1)
    local rep = fc.rep(itarget, 2)
    print('first', itarget[1])
    print('never use fc.len() with iter')
    for i=1, #rep[1] do
        print(rep[1][i])
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
    print('join with metatable')
    local tab2 = {42,['code']={'lua',1993}}
    setmetatable(tab2, {__index=tab2,__tostring=function(_)
                                            return 'meta2' end})

    local meta_join=fc.join(0, tab2)
    print(meta_join,'meta_join.code==tab2.code', meta_join.code==tab2.code)

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

    print('\nmapr')
    local recursive = fc.mapr(tostring, target)
    fc.gkv(recursive)
    print('string in table')
    fc.gkv(recursive['bit'])
    print('print all items recursevly')
    fc.mapr(print, target)
    print('len all items recursevly')
    local maprlen=fc.mapr(string.len,recursive)
    fc.gkv(fc.join(maprlen,maprlen['bit']))
    print('use mapr for varg with zip like in python map')
    fc.mapr(print,{unpack(fc.zip(target,{1,42,196}))})
    print('use straight')
    fc.mapr(print,{target,{0,1},'whoami',{code='lua'}})

    local array = {16, 32, 64, 128}
    local mixarr = {'moon', 'lua', 'code',0, false, nil}
    print('\nfilter')
    print('string only')
    fc.gkv(fc.filter(function(x) return type(x) == 'string' end, mixarr))
    print('> 32')
    fc.gkv(fc.filter(function (x) return x > 32 end, array))
    print('len > 3')
    fc.gkv(fc.filter(function(x) return tostring(x):len() > 3 end , mixarr))

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
    local sep_two = fc.zip(unpack(fc.rep(fc.iter(fc.range(6)),2)))
    fc.map(fc.gkv,sep_two)
    print('zip two iter')
    local iter_zip = fc.zip(unpack(fc.rep(fc.iter(target),2)))
    fc.map(fc.gkv,iter_zip)

    print('\npartial')
    print('make print # function')
    local print_she = fc.partial(print, '#')
    print_she('whoami','code')
    print('make map to string function')
    local mapstr = fc.partial(fc.map, tostring)
    fc.gkv(mapstr(array))
    print('make filter for numbers')
    local filter_str = fc.partial(fc.filter,
                               function(x) return type(x) == 'number' end)
    fc.gkv(filter_str(mixarr))

    print('\nreduce')
    local nested = {{1,0},{0,1},{0,0},1,1,{42,42}}
    print(fc.reduce(function(x, y) return  x + y end, {1,2,4,8,16,32,64,128}))
    print('flat table')
    fc.gkv(fc.reduce(fc.join,nested))

    print('\ncompose')
    print('exclude gkv')
    local no_gkv = fc.compose(fc.gkv, mapstr)
    no_gkv(mixarr)
    print('make lent for all items')
    local maplent = fc.partial(fc.map, string.len)
    print('exclude lent')
    local no_lent = fc.compose(maplent, fc.compose(mapstr, filter_str))
    fc.gkv(no_lent(mixarr))

    print('\npermutation')
    local mut=fc.permutation(fc.range(3))
    fc.map(function(x) print(table.concat(x,' ')) end, mut)
    local mut=fc.permutation({'a','b','c'})
    fc.map(function(x) print(table.concat(x,' ')) end, mut)

    print('\nrandkey', target[fc.randkey(target)])
    print('\nrandval', fc.randval(target))
    print('randval 100', fc.randval(fc.range(100)))

    print('\nshuff')
    local shuffle_tar = fc.shuff(target)
    print('target')
    fc.gkv(target)
    print('shuffle_tar')
    fc.gkv(shuffle_tar)

    print('\nshuffknuth')
    fc.gkv(fc.shuffknuth(fc.range(5)),' ')

    local shuffle_k = fc.shuffknuth(target)
    print('target')
    fc.gkv(target)
    print('shuffle_k')
    fc.gkv(shuffle_k)

    print('shuffknuth perfomance')
    local tclk = os.clock()
    local str= 'Hello W'
    local hell=fc.split(str)

    for _=1, math.huge do
        hell=fc.shuffknuth(hell)
        if table.concat(hell)==str then break end
    end
    print(os.clock() -  tclk)
    print(table.concat(hell))

    print('\nuncomment to check error when pass wrong values to function')
    -- fc.gkv('lua')
end

test()
