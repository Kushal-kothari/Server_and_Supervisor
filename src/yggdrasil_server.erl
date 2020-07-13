-module(yggdrasil_server).

-behaviour(gen_server).  %% we want to declare a behaviour which is gen server.

%% API
-export([ stop/0, start_link/0,yggdrasil_connect/2]). %what client can see

%%GEN SERVER
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


% %%%%%%%%%%%%%%%%% CLIENT CALL

yggdrasil_connect(Port, Yggdrasil) ->
    gen_server:call({global, ?MODULE}, {yggdrasil_connect,Port, Yggdrasil}).


stop() ->
    gen_server:call({global, ?MODULE}, stop).

start_link() ->
    gen_server:start_link({global, ?MODULE},?MODULE,[],[]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          CALLBACK FUNCTIONS               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% WHEN THE FACTORIAL SERVER IS INITIALIZED THE INIT FUNCTION IS ALWAYS CALLED DIRECTLY
%% 


init(_Args) ->
    process_flag(trap_exit, true), %it sets the trap exit  it ensures that the supervisor recieves notification if the server goes down
    io:format("~p (~p) starting . . . ~n", [{local, ?MODULE}, self()]),
    {ok, []}.




handle_call({yggdrasil_connect,Port, Yggdrasil}, _From, State) -> % handle call is a synchronise function.it basically going to call the factorial logic % and it is going to wait for a reply.this is crucil bcoz it is going to wait so if the factorial logic function takes ages basically the srever is actually going to wait till it recieves a reply.We can fix that by putting a timeout here and once the tout of 2000 is up.to terminate handle information kicks in
     {reply, yggdrasil_logic:yggdrasil_connect(Port, Yggdrasil), State};

handle_call(_Request, _From, State) ->                                        
    {reply, ok, State}.


handle_cast(_Msg, State) -> %%handle cast is asynchromous and in general not for returing values.
    {noreply, State}.

handle_info(_Info, State) ->  %handle info is called by gen_server when the timeout occurs so we go to the handle_cast
    {noreply, State}.

terminate(_Reason, _State) -> %terminate is called when we terminate the server.
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
%%we want to declare a behaviour which is gen server.


% Now we have the callback functions,Now we beed to create CLIENT CALL FUNCTioNS .Basically this are the functions client can send to the server

% For the purpose of this tut we hav start_link and stop.In the next tutorial we are going to remove them and make sure supervisor
% is the one that strtsthe link.then we have the 2 factorial calls which client requests and then server sends the payload to 
% the callback function which calls the logic and then sends a reply back.So what we want to do know is we want to create a another
%  another handle call which is going to handle the factorial See [10]