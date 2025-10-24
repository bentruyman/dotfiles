" keywords
syntax keyword teaStatement   use var def struct return
syntax keyword teaConditional if unless else end for of while until
syntax keyword teaBoolean     true false nil

" numbers and strings
syntax match  teaNumber       /\<[0-9][_0-9]*\>/
syntax region teaString start=/"/ skip=/\\"/ end=/"/
syntax match  teaComment      /#.*/

highlight def link teaStatement   Keyword
highlight def link teaConditional Conditional
highlight def link teaBoolean     Boolean
highlight def link teaNumber      Number
highlight def link teaString      String
highlight def link teaComment     Comment
