# shellcheck shell=bash

bash_json.parse() {
	unset -v REPLY; REPLY=

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

	# Print tokens
	printf '\n%s\n' "Tokens:"
	local token= i=0
	for token in "${TOKENS[@]}"; do
		printf '%s\n' "($i) token: $token"
		i=$((i+1))
	done

	# Different paths for if token stream starts with object, array, or "singleton"
	if [ "${TOKENS[0]}" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
		bash_json.helper_check_declare_array_or_object

		__var_type='object'
	elif [ "${TOKENS[0]}" = 'TOKEN_OPEN_SQUAREBRACKET' ]; then
		bash_json.helper_check_declare_array_or_object

		__var_type='array'
	elif [ "${TOKENS[0]::1}" = $'\x01' ]; then
		bash_json.helper_check_declare_primitive

		__var_type='string'
	elif [ "${TOKENS[0]::1}" = $'\x02' ]; then
		bash_json.helper_check_declare_primitive

		__var_type='number'
	fi
}
