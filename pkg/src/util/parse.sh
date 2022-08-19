# shellcheck shell=bash

bash_json.parse_object() {
	unset -v REPLY; REPLY=
	local variable_prefix="$1"
	local idx="$2"
	local hier="$3"

	# Until we see a closing curley brace, we inspect each key-value pair
	until [ "$idx_value_0" = 'TOKEN_CLOSE_CURLEYBRACE' ]; do
		bash_json_get_idx_values $((idx))
		local idx_value_0="$REPLY1" idx_row_0="$REPLY2" idx_col_0="$REPLY3" idx_value_0_raw="$REPLY4"
		bash_json_get_idx_values $((idx+1))
		local idx_value_1="$REPLY1" idx_row_1="$REPLY2" idx_col_1="$REPLY3" idx_value_1_raw="$REPLY4"
		bash_json_get_idx_values $((idx+2))
		local idx_value_2="$REPLY1" idx_row_2="$REPLY2" idx_col_2="$REPLY3" idx_value_2_raw="$REPLY4"
		bash_json_get_idx_values $((idx+3))
		local idx_value_3="$REPLY1" idx_row_3="$REPLY2" idx_col_3="$REPLY3" idx_value_3_raw="$REPLY4"

		# The
		if ((idx + 1 > ${#TOKENS[@]} )); then
			bash_json_get_idx_values $((idx - 1))
			local idx_value_0="$REPLY1" idx_row_0="$REPLY2" idx_col_0="$REPLY3" idx_value_0_raw="$REPLY4"
			local -i hoisted_n=0
			bash_json.util_die "Forgot to close an opening curley brace or bracket"
		fi

	# 	printf '%s\n' "JJ: $idx_value_0 | $idx_value_1 | $idx_value_2 | $idx_value_3"
	# 	# 0
	# 	local -i hoisted_n=0
	# 	if ! bash_json.util_is_string "$idx_value_0_raw"; then
	# 		bash_json.util_die "Expected a literal or object or array (dangling comma?)"
	# 	fi

	# 	# 1
	# 	hoisted_n=1
	# 	if [ "$idx_value_1" != 'TOKEN_COLON' ]; then
	# 		bash_json.util_die "Expected a colon after an object key"
	# 	fi

	# 	# 2
	# 	hoisted_n=2
	# 	if bash_json.util_is_primitive "$idx_value_2"; then
	# 		bobject set-string --ref "$variable_prefix" "$hier.$idx_value_0" 'idx_value_2'
	# 	elif [ "$idx_value_2" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
	# 		# echo descending to "$hier$idx_value_0" $idx
	# 		local -A obj=()
	# 		local str="$hier${idx_value_0:1}"
	# 		# bobject set-object --ref "$variable_prefix" "$str" 'obj'
	# 		# bash_json.parse_array_or_object "$variable_prefix" $((idx+2)) "$str"
	# 		continue
	# 	else
	# 		bash_json.util_die "Expected a literal or object or array (as key of object)"
	# 	fi

	# 	# 3
	# 	hoisted_n=3
	# 	if [ "$idx_value_3" = 'TOKEN_COMMA' ]; then
	# 		:
	# 	elif [ "$idx_value_3" = 'TOKEN_CLOSE_CURLEYBRACE' ]; then
	# 		break
	# 	else
	# 		bash_json.util_die "Invalid, expected either comma or squigly bracket (got $idx_value_3)"
	# 	fi

	# 	# Continue loop
		idx=$((idx+4))
	# 	bash_json.util_is_within_bounds "$idx" 'Expected closing squigly 2'
	done

	REPLY=$idx

	# # object
	# if [ "$idx_value_0" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
	# 	idx=$((idx+1))
	# 	bash_json_get_idx_values "$idx"
	# 	local idx_value_0="$REPLY1"; idx_row_0="$REPLY2" idx_col_0="$REPLY3" idx_value_0_raw="$REPLY4"
	# 	bash_json.util_is_within_bounds "$idx" 'Expected closing square curley bracket 1'

	# 	# Until we see a closing curley brace, we inspect each key-value pair
	# 	until [ "$idx_value_0" = 'TOKEN_CLOSE_CURLEYBRACE' ]; do
	# 		bash_json_get_idx_values $((idx))
	# 		local idx_value_0="$REPLY1" idx_row_0="$REPLY2" idx_col_0="$REPLY3" idx_value_0_raw="$REPLY4"
	# 		bash_json_get_idx_values $((idx+1))
	# 		local idx_value_1="$REPLY1" idx_row_1="$REPLY2" idx_col_1="$REPLY3" idx_value_1_raw="$REPLY4"
	# 		bash_json_get_idx_values $((idx+2))
	# 		local idx_value_2="$REPLY1" idx_row_2="$REPLY2" idx_col_2="$REPLY3" idx_value_2_raw="$REPLY4"
	# 		bash_json_get_idx_values $((idx+3))
	# 		local idx_value_3="$REPLY1" idx_row_3="$REPLY2" idx_col_3="$REPLY3" idx_value_3_raw="$REPLY4"

	# 		printf '%s\n' "JJ: $idx_value_0 | $idx_value_1 | $idx_value_2 | $idx_value_3"
	# 		# 0
	# 		local -i hoisted_n=0
	# 		if ! bash_json.util_is_string "$idx_value_0_raw"; then
	# 			bash_json.util_die "Expected a literal or object or array (dangling comma?)"
	# 		fi

	# 		# 1
	# 		hoisted_n=1
	# 		if [ "$idx_value_1" != 'TOKEN_COLON' ]; then
	# 			bash_json.util_die "Expected a colon after an object key"
	# 		fi

	# 		# 2
	# 		hoisted_n=2
	# 		if bash_json.util_is_primitive "$idx_value_2"; then
	# 			bobject set-string --ref "$variable_prefix" "$hier.$idx_value_0" 'idx_value_2'
	# 		elif [ "$idx_value_2" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
	# 			# echo descending to "$hier$idx_value_0" $idx
	# 			local -A obj=()
	# 			local str="$hier${idx_value_0:1}"
	# 			# bobject set-object --ref "$variable_prefix" "$str" 'obj'
	# 			# bash_json.parse_array_or_object "$variable_prefix" $((idx+2)) "$str"
	# 			continue
	# 		else
	# 			bash_json.util_die "Expected a literal or object or array (as key of object)"
	# 		fi

	# 		# 3
	# 		hoisted_n=3
	# 		if [ "$idx_value_3" = 'TOKEN_COMMA' ]; then
	# 			:
	# 		elif [ "$idx_value_3" = 'TOKEN_CLOSE_CURLEYBRACE' ]; then
	# 			break
	# 		else
	# 			bash_json.util_die "Invalid, expected either comma or squigly bracket (got $idx_value_3)"
	# 		fi

	# 		# Continue loop
	# 		idx=$((idx+4))
	# 		bash_json.util_is_within_bounds "$idx" 'Expected closing squigly 2'
	# 	done

	# 	REPLY=$idx
	# # array
	# elif [ "$idx_value_0" = 'TOKEN_OPEN_SQUAREBRACKET' ]; then
	# 	local -a temporary_array=()

	# 	idx=$((idx+1))
	# 	idx_value_0="${TOKENS[$idx]}"
	# 	bash_json.util_is_within_bounds "$idx" 'Expected closing square bracket 1'

	# 	until [ "$idx_value_0" = 'TOKEN_CLOSE_SQUAREBRACKET' ]; do
	# 		idx_value_0="${TOKENS[$idx]}"
	# 		local idx_value_1="${TOKENS[$idx+1]}"

	# 		# 0
	# 		if bash_json.util_is_primitive "$idx_value_0"; then
	# 			temporary_array+=("${idx_value_0:1}")
	# 			# bash_json.parse_array_or_object "$idx"
	# 		else
	# 			# TODO: ALPHA
	# 			core.print_die "Expected a literal or object or array (dangling comma)"
	# 		fi

	# 		# 1
	# 		if [ "$idx_value_1" = 'TOKEN_COMMA' ]; then
	# 			:
	# 		elif [ "$idx_value_1" = 'TOKEN_CLOSE_SQUAREBRACKET' ]; then
	# 			break
	# 		else
	# 			core.print_die "Invalid, expected either comma or square bracket (got $idx_value_1)"
	# 		fi

	# 		# Continue loop
	# 		idx=$((idx+2))
	# 		bash_json.util_is_within_bounds "$idx" 'Expected closing square bracket 2'
	# 	done

	# 	unset -v REPLY; declare -ga REPLY=()
	# 	bobject set-array --ref "$variable_prefix" "$hier" 'temporary_array'
	# fi
}

bash_json.parse_primitive() {
	unset -v REPLY; REPLY=

	if ((${#TOKENS[@]} > 1)); then
		core.print_die "If parsing a string or number, there can be only one"
	fi

	REPLY="${TOKENS[0]}"
}
