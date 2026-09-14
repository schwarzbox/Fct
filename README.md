# Fct

## v4.7

Functional tools for Lua.

### Usage

Install [Lua 5.4](https://lua.org/ftp/).

Copy `fct.lua` to the project folder or to a directory in the `LUA_PATH`.

#### Minimal Example

`main.lua`
``` lua
local fct = require('fct')

fct.len({0, ['fct'] = {0, 1}})
```

#### Complete Example

Advanced examples are available in the `test.lua` file.

### API Reference

#### Table

`fct.gkv` - get and print key-value pairs of the given table.

`fct.len` - return the number of all elements in the given table.

`fct.count` - return the number of times a given value occurs in the given table.

`fct.keys, fct.vals` - return the keys or values of the given table.

`fct.items` - return a new table containing the key-value pairs of the given table as two-element tables.

`fct.iskey, fct.isval` - return `true` if the given key or value exists in the given table; otherwise return `false`.

`fct.index` - return the index of the given item in the given table.

`fct.flip` - swap the keys and values of the given table.

`fct.range` - return a table containing a range of numbers.

`fct.rep` - replicate an item `n` times and return a table of items.

`fct.split` - convert a string or number into a table of characters or separated parts.

`fct.invert` - reverse the numeric keys of the given table and preserve non-numeric keys.

`fct.slice` - return a slice of the given table.

`fct.sep` - return the given table separated into tables containing `n` elements.

`fct.copy` - return a recursive copy of the given table.

`fct.iter` - make the given table iterable and return values when accessed by index.

`fct.equal` - return `true` if the two tables have the same number of elements and corresponding key-value pairs are equal.

`fct.join` - return a table created by joining the given arguments.

`fct.set`   - return a table containing the values of the given table as both keys and values.

`fct.union` - return a table containing unique values from the given two tables.

`fct.same` - return a table containing values occurring in both given tables.

`fct.diff` - return a table containing values occurring in only one of the given tables.

#### Sorting

`fct.isort` - return an iterator for sorting table keys, or sorting keys according to their values, with optional reverse ordering.

#### Functional

`fct.each` - call a given function or method for each element in the given table.

`fct.map` - call a given function for each element in the given table and return a new table.

`fct.mapr` - call a given function for each element in the given table recursively and return a new table.

`fct.filter` - filter the given table using a given function and return a new table.

`fct.any` - return `true` if any item in the table is truthy.

`fct.all` - return `true` if all items in the table are truthy.

`fct.zip` - aggregate corresponding elements from multiple tables into a new table, stopping at the shortest table.

`fct.reduce` - apply a given function successively to the elements of the given table and return a single value.

`fct.partial` - return a function with its first argument fixed.

`fct.compose` - return a function constructed from two functions provided as arguments.

`fct.chain` - combine multiple functions into a single function.

`fct.cache` - return a function that caches the results of another function.

`fct.accumulate` - return a table containing accumulated results; addition is used by default or a given function can be supplied.

#### Combinatorics

`fct.permutation` - return a table of tables containing all permutations of the given table.

`fct.combination` - return a table of tables containing combinations of elements taken `k` at a time without repetitions from the given table.

#### Random

`fct.randkey, fct.randval` - return a random key or value from the given table.

`fct.shuff` - return a mixed version of the given table.

`fct.shuffknuth` - return a mixed version of the given table, faster than `fct.shuff` but only for tables with numeric keys.

`fct.weighted` - select a key according to the weights of the given table.

### Credits

Code: [Aliaksandr Veledzimovich](https://twitter.com/veledzimovich)
