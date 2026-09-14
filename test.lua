#!/usr/bin/env lua
-- FCT
-- test.lua

-- Copyright (c) 2018 Aliaksandr Veledzimovich [[veledz@gmail.com]]
-- SPDX-License-Identifier: MIT

-- lua<5.3
local utf8 = require('utf8')
local unpack = table.unpack or unpack

local fct = require('fct')

local function gkv(...)
    for key, value in pairs(...) do
        if type(value) == 'table' then
            for nested_key, nested_value in pairs(value) do
                print(nested_key, nested_value, type(nested_value))
            end
        else
            print(key, value)
        end
    end
end

local function tables()
    local target = {
        0,
        1,
        gkv,
        ['lua'] = 'moon',
        ['bit'] = {0, 1}
    }

    print('\ngkv')
    fct.gkv(target)


    print('\nlen', fct.len(target), #target)
    assert(fct.len(target) == 5)


    print('\ncount', fct.count(0, target))
    assert(fct.count(0, target) == 1)


    print('\nkeys')
    gkv(fct.keys(target))


    print('\nvals')
    gkv(fct.vals(target))


    print('\nitems')
    local items = fct.items(target)
    gkv(items)

    local found = false
    for _, item in pairs(items) do
        if item[1] == 'lua' and item[2] == 'moon' then
            found = true
            break
        end
    end

    assert(found)


    print('\niskey', fct.iskey('bit', target) ~= nil)
    assert(fct.iskey('bit', target) ~= false)


    print('\nisval')
    assert(fct.isval('moon', target) ~= false)


    print('\nindex')
    assert(fct.index(0, target) == 1)
    assert(fct.index('moon', target) == 'lua')


    print('\nflip')
    local days = {
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday'
    }
    local reversed_days = fct.flip(days)
    gkv(reversed_days)
    print(fct.isval('Sunday', days))

    assert(reversed_days.Sunday == 1)


    print('\nrange')
    gkv(fct.range())

    local range = fct.range(1, 5, 2)
    gkv(range)
    gkv(fct.range(3, 1, -1))

    for index = 1, #fct.range(3) do
        print('range', index)
    end
    assert(range[1] == 1 and range[2] == 3 and range[3] == 5)


    print('\nrep')
    local repeated_values = fct.rep('lua', 4)
    gkv(repeated_values)

    print('randtab')
    gkv(fct.rep(math.random(), 4))

    print('matrix')
    local matrix = {}
    for row = 1, 2 do
        matrix[row] = fct.rep(0, 8)
    end
    print(
        table.concat(matrix[1], ' '),
        table.concat(matrix[2], ' ')
    )

    assert(#repeated_values == 4)


    print('\nsplit')
    gkv(fct.split('code'))
    gkv(fct.split('code lua 42 196', ' '))
    gkv(fct.split(196, ''))
    gkv(fct.split('no sense', '42'))
    gkv(fct.split('⌘ utf8 й', ' '))
    gkv(fct.split('⌘ utf8 й', ''))
    gkv(fct.split('⌘utf8⌘utf8⌘utf8⌘', '⌘'))

    assert(#fct.split('code') == 4)


    print('\ninvert')
    local inverted_target = fct.invert(target)
    gkv(inverted_target)
    print(inverted_target[2])

    assert(
        fct.equal(inverted_target, {
            gkv,
            1,
            0,
            lua = 'moon',
            bit = {0, 1}
        })
    )


    print('\nslice')
    gkv(fct.slice({1, 2, 3, 'lua'}, 2, 4, 2))
    gkv(fct.slice(target, 2))
    gkv(fct.slice(target, 2, #target))
    gkv(fct.slice(target, 4, fct.len(target)))
    local sliced = fct.slice({1, 2, 3, 'lua'}, 2, 4, 2)
    assert(sliced[1] == 2 and sliced[2] == 'lua')


    print('\nsep')
    fct.map(gkv, fct.sep(target, 2))

    local separated = fct.sep(target, 2)
    assert(#separated == 2)


    print('\ncopy')
    local copied_target = fct.copy(target)
    local second_copied_target = fct.copy(target)
    print('copy', copied_target ~= second_copied_target)

    print(
        'deep copy',
        copied_target['bit'] ~= second_copied_target['bit']
    )

    print('meta copy')
    local iterator_source = {
        0,
        42,
        ['code'] = {}
    }
    local source_metatable = setmetatable(iterator_source, {
        __index = iterator_source,
        __len = function(self)
            return fct.len(self)
        end
    })
    local copied_metatable_table = fct.copy(source_metatable)
    print(
        'meta copy false',
        copied_metatable_table == source_metatable
    )
    print(
        'meta tables false',
        getmetatable(copied_metatable_table)
            == getmetatable(source_metatable)
    )
    print(
        'use meta method',
        #copied_metatable_table,
        #source_metatable
    )
    getmetatable(copied_metatable_table).__len = nil
    print(
        'use meta method',
        #copied_metatable_table,
        #source_metatable
    )
    print(
        'source_metatable still have function',
        getmetatable(source_metatable).__len
    )
    print(
        'source_metatable[1] copied_metatable_table[1]',
        source_metatable[1],
        copied_metatable_table[1]
    )
    print(
        'source_metatable[2] == copied_metatable_table[2]',
        source_metatable['code'] == copied_metatable_table['code']
    )

    assert(
        copied_target ~= second_copied_target
        and copied_target['bit'] ~= second_copied_target['bit']
    )


    print('\niter')
    local iterator_target = fct.iter(iterator_source)
    local iterator_replicates = fct.rep(iterator_target, 2)
    print('first', iterator_target[1])
    print('never use fct.len() with iter')

    print('iter.__index use together keys and index')
    for index = 1, #iterator_replicates[1] do
        print(iterator_replicates[1][index])
    end
    print(
        'first from rep1',
        iterator_replicates[1][1],
        'first from rep2',
        iterator_replicates[2][1]
    )

    assert(iterator_target[2] ~= iterator_source[2])


    print('\nequal', fct.equal(copied_target, second_copied_target))
    print(fct.equal(target, target))

    local equal_target = fct.partial(fct.equal, {1, 1})
    local equality_results = fct.map(equal_target, {
        {1, 0},
        {0, 1},
        {0, 0},
        {1, 1}
    })
    gkv(equality_results)

    print(fct.equal(
        {1, 2, lua = 'moon'},
        {1, 2, code = 'lua'}
    ))

    assert(fct.equal(copied_target, second_copied_target))

    assert(not fct.equal(
        {1, 2, lua = 'moon'},
        {1, 2, code = 'lua'}
    ))

    assert(fct.equal(
        {1, 2, {3, 4}},
        {1, 2, {3, 4}}
    ))

    assert(not fct.equal(
        {1, 2, {3, 4}},
        {1, 2, {3, 5}}
    ))


    print('\njoin')
    print('no fargs', fct.join())

    gkv(fct.join(target, {'join', zero = 0}))

    print('join tables and values')
    gkv(fct.join({1, 0}, 42))

    print('join fargs')
    gkv(fct.reduce(fct.join, {
        {1, 0},
        42,
        {['lua'] = 1993},
        {196, ['code'] = 'lua'}
    }))

    print('join with metatable')
    local metatable_source = {
        42,
        ['code'] = {'lua', 1993}
    }
    setmetatable(metatable_source, {
        __index = metatable_source,
        __tostring = function(_)
            return 'meta2'
        end
    })
    local joined_metatable_table = fct.join(0, metatable_source)
    print(
        joined_metatable_table,
        'joined_metatable_table.code == metatable_source.code',
        joined_metatable_table.code == metatable_source.code
    )

    assert(joined_metatable_table.code ~= metatable_source.code)

    assert(fct.equal(
        joined_metatable_table.code,
        metatable_source.code
    ))


    print('\nset')
    local set = fct.set(target)
    gkv(set)
    assert(set.moon == 'moon')


    print('\nunion')
    local union = fct.union(target, {0, 1, 42})
    gkv(union)
    assert(fct.isval(42, union) ~= false)

    print('\nsame')
    local same = fct.same(target, {0, 1, 42})
    gkv(same)
    assert(fct.isval(0, same) ~= false)

    print('\ndiff')
    local diff = fct.diff(target, {0, 1, 42})
    gkv(diff)
    assert(fct.isval(42, diff) ~= false)
end

local function sorting()
    print('\nisort')
    local code = {
        ['lua'] = 1993,
        ['c'] = 1970,
        ['swift'] = 2013
    }
    for key, value in fct.isort(code, nil, true) do
        print(key, value)
    end
end

local function functional()
    local target = {
        0,
        1,
        gkv,
        ['lua'] = 'moon',
        ['bit'] = {0, 1}
    }

    local array = {16, 32, 64, 128}
    local mixed_values = {'moon', 'lua', 'code', 0, false, nil}


    print('\neach')
    local objects = {
        {say = function(message) print(message) end},
        {say = function(message) print(message) end}
    }
    fct.each('say', objects)
    fct.each(print, objects)


    print('\nmap')
    gkv(fct.map(table.concat, {{'map'}, {0, 1}}))
    gkv(fct.map(tostring, fct.range(1, 3)))

    print('len all items')
    gkv(fct.map(string.len, fct.map(tostring, target)))

    print('print values')
    fct.map(print, target)

    assert(fct.map(tostring, fct.range(1, 3))[1] == '1')


    print('\nmapr')
    local recursive_result = fct.mapr(tostring, target)
    gkv(recursive_result)

    print('string in table')
    gkv(recursive_result['bit'])

    print('print all items recursively')
    fct.mapr(print, target)

    print('len all items recursively')
    local recursive_lengths = fct.mapr(string.len, recursive_result)
    gkv(fct.join(
        recursive_lengths,
        recursive_lengths['bit']
    ))

    print('use mapr for varg with zip like in python map')
    fct.mapr(print, {
        unpack(fct.zip(target, {1, 42, 196}))
    })

    print('use straight')
    fct.mapr(print, {
        target,
        {0, 1},
        'whoami',
        {code = 'lua'}
    })

    assert(type(recursive_result['bit']) == 'table')


    print('\nfilter')
    print('string only')
    gkv(fct.filter(
        function(value)
            return type(value) == 'string'
        end,
        mixed_values
    ))

    print('> 32')
    gkv(fct.filter(
        function(value)
            return value > 32
        end,
        array
    ))

    print('len > 3')
    gkv(fct.filter(
        function(value)
            return tostring(value):len() > 3
        end,
        mixed_values
    ))

    local strings = fct.filter(
        function(value)
            return type(value) == 'string'
        end,
        mixed_values
    )

    assert(#strings == 3)


    print('\nany')
    print(fct.any(array))
    print(fct.any(mixed_values))

    print(not fct.any(fct.map(
        function(value)
            return type(value) == 'string'
        end,
        mixed_values
    )))

    print(fct.any({false, nil}))
    print(fct.any({0, 0, 0}))

    assert(fct.any({0, 0, 0}) == true)


    print('\nall')
    print(fct.all(array))
    print(fct.all(mixed_values))

    print(fct.all(fct.map(
        function(value)
            return type(value) == 'string'
        end,
        mixed_values
    )))

    print(fct.all({false, nil}))
    print(fct.all({0, 0, 0}))

    assert(fct.all({0, 0, 0}) == true)


    print('\nzip')
    local zipped = fct.zip(array, mixed_values)
    fct.map(gkv, zipped)

    print('unzip')
    local unzipped = fct.zip(unpack(zipped))

    fct.map(gkv, unzipped)

    print('only for num keys')
    local key_table = {['key'] = 'key'}
    local numeric_table = {1, 0}
    fct.map(gkv, fct.zip(key_table, numeric_table))

    print('zip like sep')
    local repeated_iterators = fct.rep(
        fct.iter(fct.range(6)),
        2
    )

    local zipped_iterators = fct.zip(
        unpack(repeated_iterators)
    )
    fct.map(gkv, zipped_iterators)

    print('zip two iter')
    local repeated_target_iterators = fct.rep(
        fct.iter(target),
        2
    )

    local zipped_target_iterators = fct.zip(
        unpack(repeated_target_iterators)
    )
    fct.map(gkv, zipped_target_iterators)

    assert(type(zipped) == 'table')


    print('\nreduce')
    print(fct.reduce(
        function(first_value, second_value)
            return first_value * second_value
        end,
        {1}
    ))
    local sum = fct.reduce(
        function(first_value, second_value)
            return first_value + second_value
        end,
        {1, 2, 4, 8, 16, 32, 64, 128}
    )
    print(sum)

    print('flat table')
    local nested = {
        {1, 0},
        {0, 1},
        {0, 0},
        1,
        1,
        {42, 42}
    }
    gkv(fct.reduce(fct.join, nested))

    assert(sum == 255)


    print('\npartial')
    print('make print # function')
    local print_shell = fct.partial(print, '#')
    print_shell('whoami', 'code')

    print('make map to string function')
    local map_to_string = fct.partial(fct.map, tostring)
    gkv(map_to_string(array))

    print('make filter for numbers')
    local filter_numbers = fct.partial(
        fct.filter,
        function(value)
            return type(value) == 'number'
        end
    )
    gkv(filter_numbers(mixed_values))

    assert(type(map_to_string) == 'function')


    print('\ncompose')
    print('exclude gkv')
    local print_without_gkv = fct.compose(gkv, map_to_string)
    print_without_gkv(mixed_values)

    print('make length for all items')
    local map_string_length = fct.partial(fct.map, string.len)

    print('exclude length')
    local string_length_pipeline = fct.compose(
        map_string_length,
        fct.compose(map_to_string, filter_numbers)
    )
    gkv(string_length_pipeline(mixed_values))

    assert(type(print_without_gkv) == 'function')


    print('\nchain')
    local enemies = {
        {hp = 10, wound = false},
        {hp = 5, wound = true}
    }

    local enemy_update_chain = fct.chain(
        function(enemy)
            enemy.hp = enemy.hp - 1
        end,
        function(enemy)
            enemy.wound = true
        end
    )
    enemy_update_chain(enemies[1])
    gkv(enemies[1])

    assert(
        enemies[1].hp == 9
        and enemies[1].wound == true
    )


    print('\ncache')
    local cached_cosine = fct.cache(math.cos)
    print(cached_cosine(1))
    print(cached_cosine(1))

    assert(cached_cosine(1) == cached_cosine(1))


    print('\naccumulate')
    local accumulated = fct.accumulate(fct.range(5))
    print(unpack(accumulated))
    print(unpack(fct.accumulate(
        fct.range(5),
        function(first_value, second_value)
            return first_value * second_value
        end
    )))

    assert(#accumulated == 5)
end

local function combinatorics()
    print('\npermutation')
    local permutations = fct.permutation(fct.range(3))
    fct.map(
        function(permutation)
            print(table.concat(permutation, ' '))
        end,
        permutations
    )
    permutations = fct.permutation({'a', 'b', 'c'})

    fct.map(
        function(permutation)
            print(table.concat(permutation, ' '))
        end,
        permutations
    )

    assert(#permutations == 6)


    print('\ncombinations')
    local combinations = fct.combination(
        {0, 1, 2, 3},
        3
    )
    print('combinations', #combinations)

    fct.map(
        function(combination)
            print(table.concat(combination, ' '))
        end,
        combinations
    )
    local range_combinations = fct.combination(
        fct.range(0, 1, 0.1),
        3
    )
    fct.map(
        function(combination)
            print(table.concat(combination, ' '))
        end,
        range_combinations
    )

    assert(#combinations == 4)
end

local function random()
    local target = {
        0,
        1,
        gkv,
        ['lua'] = 'moon',
        ['bit'] = {0, 1}
    }


    print('\nrandkey')
    local random_key = fct.randkey(target)
    print(random_key)
    assert(fct.iskey(random_key, target) ~= false)


    print('\nrandval')
    local random_value = fct.randval(target)
    print(random_value)

    print('randval 100', fct.randval(fct.range(100)))
    assert(fct.isval(random_value, target) ~= false)


    print('\nshuff')
    local shuffled_target = fct.shuff(target)
    print('target')
    gkv(target)
    print('shuf')
    gkv(shuffled_target)

    assert(fct.len(shuffled_target) == fct.len(target))


    print('\nshuffknuth')
    gkv(fct.shuffknuth(fct.range(5)), ' ')
    local knuth_shuffled_target = fct.shuffknuth(target)
    print('target')
    gkv(target)
    print('shufk')
    gkv(knuth_shuffled_target)

    print('shuffknuth performance')
    local start_time = os.clock()
    local original_string = 'Hello W'
    local shuffled_string_chars = fct.split(original_string)
    for _ = 1, math.huge do
        shuffled_string_chars = fct.shuffknuth(
            shuffled_string_chars
        )

        if table.concat(shuffled_string_chars) == original_string then
            break
        end
    end
    print(os.clock() - start_time)
    print(table.concat(shuffled_string_chars))

    assert(table.concat(shuffled_string_chars) == original_string)


    print('\nweighted')
    local weights = {
        ['a'] = 0,
        ['b'] = 5,
        ['c'] = 10
    }
    for _ = 1, 10 do
        local weighted_key = fct.weighted(weights)
        print(weighted_key)
        assert(fct.iskey(weighted_key, weights) ~= false)
    end
end

local function test()
    tables()
    sorting()
    functional()
    combinatorics()
    random()
end

test()
