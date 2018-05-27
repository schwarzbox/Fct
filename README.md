# Fun-Lua

Functional Library (30 function + test)

Copy fun.lua to the project folder or in the directory in LUA_PATH.

Import module.
``` lua
local fc = require('fun')
```
Run examples.
``` lua
fc.test()
```

# Tool Box

gkv - print key, values and type of given table.

lent - return number of all elements in the given table.

keys - return keys of given table.

iskey, isval - return {k, v} if key/value in the given table if not return false.

array - create zero array with positive or negative indexes.

range - return table with numbers.

repl - replicate item and return table of items.

split - convert string or number to the table.

reverse - reverse table and put non number keys at the end.

slice - return slice of given table.

sep - return table separated on n-tables.

clone - return recursive copy of given table.

copy - return first level copy of given table.

iter - make iterable from table and return values when call by index.

equal - return true if tables equal.

join - return table that created from given two arguments.

merge - return table that created with keys from the first table and values from the second

map - call a given function to each element in the given table.

mapr - call a given function to each element in the given table recursevly.

mapx - apply a function to each element in the given table.

exem - call every function in table.

filter - filter table by given function.

any - return true if any item in table not nil or false.

all - return true if all item in table not nil or false.

zip -  iterates through multiple tables, and aggregates them.

partial - return function with fixed first argument.

reduce - call a function to each element in the table to reduce the table to a single value.

compose - return function constructed from two functions provided in args.

randkey, randval - return random key/value from the given table.

shuff - return the mixed version of given table.

shuffknuth - return mixed version of given table (faster then shuff but only for number indexes).

test - examples.
