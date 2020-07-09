Environment:
OS Windows 7 with Redis version 3.2.100 i.e.
https://github.com/MicrosoftArchive/redis/releases

Prerequisition to run: 
start redis server  and redis command line  in two difference console terminals

redis-server
redis-cli

API: 
Seletion of rule set and exact rule from it over Redis:

Transformation rules was set by default is Base
It can be changed by over redis i.e. by redis-cli:
> set expression "Custom 1"
or
> set expression "Custom 2"

In addition need to select exact type of conversion  "M" or "P" or T", i.e.:
>set H  M
or
>set H  P
or
>set H  M
In other case will be error returned.

Run:
To make conversion need to evaluate Lua script "eval.lua"
command format is:
redis-cli --eval path_to_lua_script keys_count , varaibles A B C D E F

Where type of iputs variables:
A: bool, B: bool, C: bool, D: float, E: int, F: int 

i.e.:
redis-cli --eval eval.lua 0 , true true false 10 1 1
redis-cli --eval eval.lua 0 , true true true 10 1 0

Notes about selection of used tools:
It looks like one of simpliest ways was to use Redis for communication/IPC and Lua script as it embedded part for expressions evalution.
Expected to work under Linux with higher Redis version with some Lua script makeup.
Can be applied other mode of communication by load script to Redis and sync calls from some application written on high level language.
As well as is possible to adopt to async PUB SUB pattern.
Not clear how can be mapped bool true/false expressions outcome to 3 states "M" "P" "T" and error, so implemented workaround to differ among that states to call different expressions.
Not tested deeply. 
Only passed over smoke test.


