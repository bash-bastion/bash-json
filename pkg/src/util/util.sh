# shellcheck shell=bash

bash_json.util_tokenize_string() {
	i=$((i+1))

	local char="${content:$i:1}"

	case $char in
	$'\x10'|$'\x11'|$'\x12'|$'\x13'|$'\x14')
		core.print_die "Unexpected whitespace in string"
		;;
	'"'|'')
		return 1
		;;
	*)
		str+="$char"
		;;
	esac

	until bash_json.util_tokenize_string; do
		return 1
	done
}

bash_json.util_tokenize_number() {
	case $char in
	$'\x09'|$'\x0B'|$'\x0C')
		core.print_die "Unexpected whitespace in number"
		;;
	','|']')
		i=$((i-1))
		return 1
		;;
	$'\x0A'|'')
		return 1
		;;
	*)
		str+="$char"
		;;
	esac

	i=$((i+1))
	local char="${content:$i:1}"

	until bash_json.util_tokenize_number; do
		return 1
	done
}

bash_json.util_is_primitive() {
	local value="$1"

	if [[ "${value::1}" = $'\x01' || "${value::1}" = $'\x02' ]]; then
		return 0
	else
		return 1
	fi
}

bash_json.util_is_within_bounds() {
	local idx="$1"
	local message="$2"

	if ((idx >= ${#TOKENS[@]} )); then
		core.print_die "$message"
	fi
}

bash_json.util_parse_array_or_object() {
	local idx="$1"
	local hier="$2"

	local idx_value="${TOKENS[$idx]}"

	if ((idx > ${#TOKENS[@]} )); then
		core.print_die "Forgot to close an opening curley brace or bracket"
	fi
	# echo zz $idx

	# object
	if [ "$idx_value" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
		idx=$((idx+1))
		idx_value=${TOKENS[$idx]}
		bash_json.util_is_within_bounds "$idx" 'Expected closing square curley bracket 1'
		# echo bbbbb $idx

		until [ "$idx_value" = 'TOKEN_CLOSE_CURLEYBRACE' ]; do
			idx_value="${TOKENS[$idx]}"
			local idx_value_1="${TOKENS[$idx+1]}"
			local idx_value_2="${TOKENS[$idx+2]}"
			local idx_value_3="${TOKENS[$idx+3]}"

			# 0
			# TODO does not correctly proces numbers
			if ! bash_json.util_is_primitive "$idx_value"; then
				core.print_die "Expected a literal or object or array (dangling comma?)"
			fi

			# 1
			if [ "$idx_value_1" != 'TOKEN_COLON' ]; then
				core.print_die "Expected a colon after an object key"
			fi

			# 2
			# TODO does not correctly proces numbers
			if bash_json.util_is_primitive "$idx_value_2"; then
				bobject set-string --ref 'GLOBAL_ROOT' "$hier.$idx_value" 'idx_value_2'
			elif [ "$idx_value_2" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
				# echo descending to "$hier$idx_value" $idx
				local -A obj=()
				local str="$hier${idx_value:1}"
				bobject set-object --ref 'GLOBAL_ROOT' "$str" 'obj'
				bash_json.util_parse_array_or_object $((idx+2)) "$str"
				# echo v___ "$REPLY"
				idx=(REPLY + 4)
				continue
			else
				core.print_die "Expected a literal or object or array (as key of object)"
			fi

			# 3
			if [ "$idx_value_3" = 'TOKEN_COMMA' ]; then
				:
			elif [ "$idx_value_3" = 'TOKEN_CLOSE_CURLEYBRACE' ]; then
				break
			else
				core.print_die "Invalid, expected either comma or squigly bracket (got $idx_value_3)"
			fi

			# Continue loop
			idx=$((idx+4))
			bash_json.util_is_within_bounds "$idx" 'Expected closing squigly 2'
		done

		REPLY=$idx
	# array
	elif [ "$idx_value" = 'TOKEN_OPEN_SQUAREBRACKET' ]; then
		local -a temporary_array=()

		idx=$((idx+1))
		idx_value="${TOKENS[$idx]}"
		bash_json.util_is_within_bounds "$idx" 'Expected closing square bracket 1'

		until [ "$idx_value" = 'TOKEN_CLOSE_SQUAREBRACKET' ]; do
			idx_value="${TOKENS[$idx]}"
			local idx_value_1="${TOKENS[$idx+1]}"

			# 0
			if bash_json.util_is_primitive "$idx_value"; then
				temporary_array+=("${idx_value:1}")
				# bash_json.util_parse_array_or_object "$idx"
			else
				# TODO: ALPHA
				core.print_die "Expected a literal or object or array (dangling comma)"
			fi

			# 1
			if [ "$idx_value_1" = 'TOKEN_COMMA' ]; then
				:
			elif [ "$idx_value_1" = 'TOKEN_CLOSE_SQUAREBRACKET' ]; then
				break
			else
				core.print_die "Invalid, expected either comma or square bracket (got $idx_value_1)"
			fi

			# Continue loop
			idx=$((idx+2))
			bash_json.util_is_within_bounds "$idx" 'Expected closing square bracket 2'
		done

		unset -v REPLY; declare -ga REPLY=()
		bobject set-array --ref 'GLOBAL_ROOT' "$hier" 'temporary_array'
	fi
}
