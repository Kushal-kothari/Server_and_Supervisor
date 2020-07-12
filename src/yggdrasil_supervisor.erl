-module(yggdrasil_supervisor).
-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init([]) ->
    io:format("~p (~p) starting . . . ~n", [{global, ?MODULE}, self()]),


%%% if maxrestarts restarts occurs in maxsecondsrestarts seconds    
%%% supervisor and child process are killed


    
    RestartStrategy = one_for_one,
    MaxRestarts = 3,
    MaxSecondsBetweenRestarts = 5,
    Flags = {RestartStrategy,MaxRestarts, MaxSecondsBetweenRestarts}, % one_for_one | one_for_all | rest_for_one | simple_one_for_one

    Restart = permanent,
    Shutdown = infinity,
    Type = worker,
    ChildSpecifications = {yggdrasilServerId, {yggdrasil_server, start_link,[]}, Restart, Shutdown, Type, [yggdrasil_server]},

    {ok, {Flags, [ChildSpecifications]}}.

    