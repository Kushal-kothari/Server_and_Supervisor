-module(yggdrasil_system).

-behaviour(application).

-export([start/2, start/0, stop/1, stop/0]).

start() ->
    application:start(?MODULE).


start(_Type, _Args) ->
    yggdrasil_supervisor:start_link().

stop() ->
    application:stop(?MODULE).

stop(_State) ->
    ok.