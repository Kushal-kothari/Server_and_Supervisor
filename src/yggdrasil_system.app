
{application, yggdrasil_system,[
    {description, "Erlang Library to connect to Yggdrasil Network"},
    {vsn, "1.0.0"},
    {module, [yggdrasil_client, yggdrasil_logic, yggdrasil_server, yggdrasil_supervisor, yggdrasil_system]},
    {registered, []},
    {application, [kernel, stdlib]},
    {mod, {yggdrasil_system, []}},
    {env, []}
]}.