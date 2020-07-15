%
% erlang_yggdrasil.erl
% A yggdrasil server written in erlang which prints back to the user whatever
% they sent. Whenever the user may want to exit, he/she has the
% possibility of closing the connection by typing "exit".
% yggdrasil_system:start().
% yggdrasil_client:yggdrasil_connect(12321,"203:18f0:c3bb:cd12:66d2:bb08:ce8d:9fde").

-module(yggdrasil_logic).
-export([yggdrasil_connect/2, connect/2, recv_loop/1]).
-compile(export_all).
-include_lib("kernel/include/logger.hrl").



% The message that the users will receive after connecting.
-define(WELCOME_MESSAGE, [
  "\x1b[32mWelcome! This is a Yggdrasil server developed under Barrel Db Labs..\x1b[0m.\r\n"]).


% What to prefix the users' input lines with.
-define(LINE_PREFIX, "> ").


yggdrasil_connect(Port,Yggdrasil) ->
  case re:run(Yggdrasil,"20") of
    {match,[{0,2}]} -> {ok,Parsed_add} = inet:parse_address(Yggdrasil),  
                       spawn(fun () -> {ok, Listen} =  gen_tcp:listen(Port, [binary,inet6,{packet, raw},{nodelay, true},{reuseaddr, true},{active, once},{ip,Parsed_add}]),
                       connect(Listen,Parsed_add)
                       end),
                       ?LOG_INFO("~p Yggdrasil Server Started.~n", [erlang:localtime()]);
    {match,_Rest} -> ?LOG_ERROR("Not a Yggdrasil address");                      
    nomatch -> ?LOG_ERROR("cannot establish connection : Check your Yggdrasil Address or if Port blocked by firewall")
   end. 


connect(Listen,Parsed_add) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  inet:setopts(Socket, [binary,inet6,{packet, raw},{nodelay, true},{reuseaddr, true},{active, once},{ip,Parsed_add}]), %add your own Yggdrasil address
  spawn_link(yggdrasil_logic, connect, [Listen,Parsed_add]),
  gen_tcp:send(Socket, ?WELCOME_MESSAGE),
  gen_tcp:send(Socket, ?LINE_PREFIX),
  recv_loop(Socket),
  gen_tcp:close(Socket).

%
% handle_data/2: handles data incoming from a connection 
%

handle_data(Socket, Data) ->
  io:format("~p ~p ~p~n", [inet:peername(Socket), erlang:localtime(), Data]),
  case Data of
    % "exit\r\n" closes the session.
    <<"exit\r\n">> ->
      io:format("~p ~p Closed.~n", [inet:peername(Socket), erlang:localtime()]),
      gen_tcp:close(Socket);
    % IAC -- Interpret As Command.
    <<255, _Rest/binary>> ->
      % handle_negotiation(Socket, Data),
      recv_loop(Socket);
    % send back all other data received.
    _ ->
      gen_tcp:send(Socket, [Data, "> "]),
      recv_loop(Socket)
  end.


% recv_loop/1: handles a connection's event loop

recv_loop(Socket) ->
  inet:setopts(Socket, [{active, once}]),
  receive
    {tcp, Socket, Data} ->
      handle_data(Socket, Data);
    {tcp_closed, Socket} ->
       ?LOG_INFO("~p Client Disconnected.~n", [erlang:localtime()])
  end.





