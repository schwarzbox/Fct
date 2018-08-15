# Fct-Lua

Functional Library (39 functions)

Copy fct.lua to the project folder or in the directory in LUA_PATH.

Import module.
``` lua
local fc = require('fct')
```
Look at examples in test.lua.

Library has functions nofarg() and numfarg() for check errors in arguments.

# Tool Box

gkv - print key, values and type of the given table.

lent - return number of all elements in the given table.

count - return count of how many times a given object occurs in given table.

keys, vals - return keys/vals of the given table.

iskey, isval - return {k, v} if key/value in the given table if not return false.

ztab - create zero table with positive or negative indexes.

range - return table with numbers.

repl - replicate item n-times and return table of items.

cut - convert string or number to the table.

reverse - reverse table and put non number keys at the end.

isort - return iterator which allow to sort and reverse table keys/values.

slice - return slice of the given table.

sep - return table separated on n-tables.

clone - return recursive copy of the given table.

iter - make iterable from the table and return values when call by index.

equal - return true if all elements(key,value) in table1 equal for all elements in table2(key,value).

join - return table that created from given two arguments.

valval - return table that created with values from the first table and values from the second.

merge - return table without duplicate values from the two tables.

same - return table with same values from the two tables.

uniq - return table with uniq values from the two tables.

map - call a given function to each element in the given table.

mapr - call a given function to each element in the given table recursevly.

filter - filter table by given function.

any - return true if any item in table not nil or false.

all - return true if all item in table not nil or false.

zip -  iterates through multiple tables, and aggregates them.

partial - return function with fixed first argument.

reduce - call a function to each element in the table to reduce the table to a single value.

compose - return function constructed from two functions provided in args.

permutation - return table of tables with all permutation for a given table.

randtab - return table with random values.

randkey, randval - return random key/value from the given table.

shuff - return the mixed version of the given table.

shuffknuth - return mixed version of the given table (faster then shuff but only for number keys).
