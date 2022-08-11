# shellcheck shell=bash

bash_json.parse() {
	# shellcheck disable=SC1007
	unset -v REPLY{1,2}; REPLY1= REPLY2=
	local variable_prefix="$1"
	local content="$2"

	local -a TOKENS=()

	# Construct token sequence
	local i=
	for ((i=0; i<${#content}; ++i)); do
		local char="${content:$i:1}"

		case $char in
			'{') TOKENS+=('TOKEN_OPEN_CURLEYBRACE') ;;
			'}') TOKENS+=('TOKEN_CLOSE_CURLEYBRACE') ;;
			'[') TOKENS+=('TOKEN_OPEN_SQUAREBRACKET') ;;
			']') TOKENS+=('TOKEN_CLOSE_SQUAREBRACKET') ;;
			':') TOKENS+=('TOKEN_COLON') ;;
			',') TOKENS+=('TOKEN_COMMA') ;;
			'"')
				local str=
				bash_json.util_tokenize_string || true
				TOKENS+=($'\x01'"$str")
				;;
			[[:digit:]])
				local str=
				bash_json.util_tokenize_number || true
				TOKENS+=($'\x02'"$str")
				;;
			' '|$'\t'|$'\n'|$'\r') ;;
			*) core.print_die "Failed: $char" ;;
		esac
	done; unset -v i

	# Print token sequence
	printf '\n%s\n' "Tokens:"
	local i=0 token=
	for token in "${TOKENS[@]}"; do
		printf '%s\n' "($i) token: $token"
		i=$((i+1))
	done

	# Construct object using token sequence
	if [ "${TOKENS[0]}" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
		bash_json.util_parse_array_or_object "$variable_prefix" 0 '.'

		REPLY1=$variable_prefix
		REPLY2='object'
	elif [ "${TOKENS[0]}" = 'TOKEN_OPEN_SQUAREBRACKET' ]; then
		bash_json.util_parse_array_or_object "$variable_prefix" 0 '.'

		REPLY1=$variable_prefix
		REPLY2='array'
	elif [ "${TOKENS[0]::1}" = $'\x01' ]; then
		bash_json.util.parse_primitive

		REPLY1=$REPLY
		REPLY2='string'
	elif [ "${TOKENS[0]::1}" = $'\x02' ]; then
		bash_json.util.parse_primitive

		REPLY1=$REPLY
		REPLY2='number'
	else
		core.panic 'Unexpected token'
	fi
}
