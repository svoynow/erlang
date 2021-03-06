%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 1999-2009. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%
%%

%%
%%----------------------------------------------------------------------
%% Purpose: Define common macros for testing
%%----------------------------------------------------------------------

-define(APPLY(Proxy, Fun),
	Proxy ! {apply, Fun}).

-define(LOG(Format, Args),
	megaco_test_lib:log(Format, Args, ?MODULE, ?LINE)).

-define(ERROR(Reason),
	megaco_test_lib:error(Reason, ?MODULE, ?LINE)).

-define(OS_BASED_SKIP(Skippable),
	megaco_test_lib:os_based_skip(Skippable)).

-define(NON_PC_TC_MAYBE_SKIP(Config, Condition),
	megaco_test_lib:non_pc_tc_maybe_skip(Config, Condition, ?MODULE, ?LINE)).

-define(SKIP(Reason),
	megaco_test_lib:skip(Reason, ?MODULE, ?LINE)).

-define(VERIFYL(Expected, Expr),
	fun(A,B) when list(A), list(B) ->
		A1 = lists:sort(A),
		B1 = lists:sort(B),
		case A1 of
		    B1 -> ?LOG("Ok, ~p~n", [B]);
		    _  -> ?ERROR(B)
		end,
		B;
	   (A,A) ->
		?LOG("Ok, ~p~n", [A]),
		A;
	   (A,B) ->
		?ERROR(B),
		B
	end(Expected, (catch Expr))).

-define(VERIFY(Expected, Expr),
	fun() ->
		AcTuAlReS = (catch (Expr)),
		case AcTuAlReS of
		    Expected -> ?LOG("Ok, ~p~n", [AcTuAlReS]);
		    _        ->	?ERROR(AcTuAlReS)
		end,
		AcTuAlReS
	end()).

-define(RECEIVE(Expected),
	?VERIFY(Expected, megaco_test_lib:flush())).

-define(MULTI_RECEIVE(Expected),
	?VERIFY(lists:sort(Expected), lists:sort(megaco_test_lib:flush()))).

-define(ACQUIRE_NODES(N, Config),
	megaco_test_lib:prepare_test_case([init, {stop_app, megaco}],
				   N, Config, ?FILE, ?LINE)).


-define(SLEEP(MSEC),    megaco_test_lib:sleep(MSEC)).
-define(M(),            megaco_test_lib:millis()).
-define(MDIFF(A,B),     megaco_test_lib:millis_diff(A,B)).
