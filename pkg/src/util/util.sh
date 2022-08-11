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
