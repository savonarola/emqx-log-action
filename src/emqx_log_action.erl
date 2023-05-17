%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%--------------------------------------------------------------------

-module(emqx_log_action).

-export([log/3]).

-define(DEFAULT_LEVEL, info).

log(Selected, _Envs, Args) ->
    Level = log_level(maps:get(level, Args, undefined)),
    logger:log(Level, format(Selected)).

%%--------------------------------------------------------------------
%% Internal functions
%%--------------------------------------------------------------------

%% Format in emqx_trace_formatter style

format(Map) when is_map(Map) ->
    kvs_to_iolist(maps:to_list(Map));
format(Term) ->
    to_iolist(Term).

to_iolist(Atom) when is_atom(Atom) -> atom_to_list(Atom);
to_iolist(Int) when is_integer(Int) -> integer_to_list(Int);
to_iolist(Float) when is_float(Float) -> float_to_list(Float, [{decimals, 2}]);
to_iolist(SubMap) when is_map(SubMap) -> ["[", kvs_to_iolist(maps:to_list(SubMap)), "]"];
to_iolist(Char) -> try_format_unicode(Char).

kvs_to_iolist(KVs) ->
    lists:join(
        ", ",
        lists:map(
            fun({K, V}) -> [to_iolist(K), ": ", to_iolist(V)] end,
            KVs
        )
    ).

try_format_unicode(undefined) ->
    "undefined";
try_format_unicode(Char) ->
    List =
        try
            case unicode:characters_to_list(Char) of
                {error, _, _} -> error;
                {incomplete, _, _} -> error;
                Binary -> Binary
            end
        catch
            _:_ ->
                error
        end,
    case List of
        error -> io_lib:format("~0p", [Char]);
        _ -> List
    end.

log_level(<<"debug">>) ->
    debug;
log_level(<<"info">>) ->
    info;
log_level(<<"notice">>) ->
    notice;
log_level(<<"warning">>) ->
    warning;
log_level(<<"error">>) ->
    error;
log_level(<<"critical">>) ->
    critical;
log_level(<<"alert">>) ->
    alert;
log_level(<<"emergency">>) ->
    emergency;
log_level(_) ->
    ?DEFAULT_LEVEL.
