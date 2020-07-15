-module(yggdrasil_server).

-behaviour(gen_server).  %% we want to declare a behaviour which is gen server.

%% API
-export([ stop/0, start_link/0,yggdrasil_connect/2]). %what client can see

%%GEN SERVER
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include_lib("kernel/include/logger.hrl").

% %%%%%%%%%%%%%%%%% CLIENT CALL %%%%%%%%%%%%%%%%%

yggdrasil_connect(Port, Yggdrasil) ->
    gen_server:call({global, ?MODULE}, {yggdrasil_connect,Port, Yggdrasil}).


stop() ->
    gen_server:call({global, ?MODULE}, stop).

start_link() ->
    gen_server:start_link({global, ?MODULE},?MODULE,[],[]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          CALLBACK FUNCTIONS               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


init(_Args) ->
    process_flag(trap_exit, true), 
     ?LOG_INFO("~p (~p) starting . . . ~n", [{local, ?MODULE}, self()]),
    {ok, []}.


handle_call({yggdrasil_connect,Port, Yggdrasil}, _From, State) -> 
     {reply, yggdrasil_logic:yggdrasil_connect(Port, Yggdrasil), State};

handle_call(_Request, _From, State) ->                                        
    {reply, ok, State}.


handle_cast(_Msg, State) -> 
    {noreply, State}.

handle_info(_Info, State) -> 
    {noreply, State}.

terminate(_Reason, _State) -> 
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
