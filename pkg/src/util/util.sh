# shellcheck shell=bash

bash_json.util_is_string() {
	local value="$1"

	if [ "${value::1}" = $'\x01' ]; then
		return 0
	else
		return 1
	fi
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

bash_json_get_idx_values() {
	unset -v REPLY{1,2,3,4}; REPLY1= REPLY2= REPLY3= REPLY4=
	local i="$1"

	REPLY1=${TOKENS[$i]##*:} # idx_value_0
	REPLY2=${TOKENS[$i]%%:*} # idx_col_0
	REPLY3=${TOKENS[$i]#*:}; REPLY3=${REPLY3%%:*} # idx_row_0
	REPLY4=${TOKENS[$i]} # idx_value_0_raw
}

bash_json.util_die() {
	local msg="$1"

	local -n row_num="idx_row_$hoisted_n"
	local -n row_col="idx_row_$hoisted_n"
	core.print_die "$msg (row $row_num, column: $row_col) (hoisted_n: $hoisted_n)"
}
