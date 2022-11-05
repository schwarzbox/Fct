# Fct

v4.6

Functional Library (42 functions)

Copy fct.lua to the project folder or in the dir in the LUA_PATH.

``` lua
local fc = require('fct')
```
Look at examples in the file test.lua

## Tool Box

len - return number of all elements in the given table.

count - return count of how many times a given object occurs in given table.

keys, vals - return keys/vals of the given table.

items - return new table which consist from {value: value} of given table

iskey, isval - return {k, v} if key/value in the given table if not return false.

flip - reverse keys and values in given table.

range - return table with numbers.

rep - replicate item n-times and return table of items.

split - convert string or number to the table.

invert- reverse table and put non number keys at the end.

isort - return iterator which allow to sort and reverse table keys/values.

slice - return slice of the given table.

sep - return table separated on n-tables.

copy - return recursive copy of the given table.

iter - make iterable from the table and return values when call by index.

equal - return true if all elements(key,value) in table1 equal for all elements in table2(key,value).

join - return table that created from given two arguments.

union - return table without duplicate values from the two tables.

same - return table with same values from the two tables.

diff - return table with different values from the two tables.

each - call a given function\method to each element in the given table

map - call a given function to each element in the given table and return new table.

mapr - call a given function to each element in the given table recursevly and return new table.

filter - filter table by given function and return new filteredtable.

any - return true if any item in table not nil or false.

all - return true if all item in table not nil or false.

zip -  iterates through multiple tables, and aggregates them.

reduce - call a function to each element in the table to reduce the table to a single value.

partial - return function with fixed first argument.

compose - return function constructed from two functions provided in args.

chain - combine together some functions.

cache - cache function.

accumulate - return table with accumulated sums. If no function is passed, addition takes place by default.

permutation - return table of tables with all permutation for a given table.

combination - return table of tables with combinations of elements taken k at a time without repetitions from given table.

randkey, randval - return random key/value from the given table.

shuff - return the mixed version of the given table.

shuffknuth - return mixed version of the given table (faster then shuff but only for number keys).

weighted - select keys by their weights.

## Support

gkv - get print key value of given table
