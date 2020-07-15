-module(yggdrasil_client).

-export([yggdrasil_connect/2]).

yggdrasil_connect(Port, Yggdrasil) ->
    yggdrasil_server:yggdrasil_connect(Port, Yggdrasil).



