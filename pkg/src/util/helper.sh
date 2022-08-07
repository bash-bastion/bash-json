# shellcheck shell=bash

bash_json.helper_check_declare_array_or_object() {
	if [ "${TOKENS[0]}" = 'TOKEN_OPEN_CURLEYBRACE' ]; then
		declare -Ag GLOBAL_ROOT=()
	elif [ "${TOKENS[0]}" = 'TOKEN_OPEN_SQUAREBRACKET' ]; then
		declare -ag GLOBAL_ROOT=()
	fi

	bash_json.util_parse_array_or_object 0 '.'

	# shellcheck disable=SC2154
	declare -gn __var="$variable_prefix"
	declare -gn __var_type="${variable_prefix}_type"
	__var='GLOBAL_ROOT' # return the bash-object
}

bash_json.helper_check_declare_primitive() {
	if ((${#TOKENS[@]} > 1)); then
		core.print_die "If parsing a string or number, there can be only one"
	fi

	# shellcheck disable=SC2154
	declare -gn __var="$variable_prefix"
	declare -gn __var_type="${variable_prefix}_type"
	__var="${TOKENS[0]}"
}
