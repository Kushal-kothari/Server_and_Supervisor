-module(yggdrasil_client).

-export([yggdrasil_kushal/2]).



yggdrasil_kushal(Port, Yggdrasil) ->
    yggdrasil_server:yggdrasil_kushal(Port, Yggdrasil).



