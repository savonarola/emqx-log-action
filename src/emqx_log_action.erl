%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%--------------------------------------------------------------------

-module(emqx_log_action).

-export([log/3]).

-define(DEFAULT_LEVEL, info).

log(Selected, _Envs, Args) ->
    Level = log_level(maps:get(level, Args, undefined)),
    logger:log(Level, Selected).

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
