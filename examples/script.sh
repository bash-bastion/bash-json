# shellcheck shell=bash

eval "$(basalt-package-init)" || exit
basalt.package-init || exit
basalt.package-load

# Test thing
# declare -Ag TEST_THING=()
# declare -ag test_array=('a' 'b' 'c' 'd')
# bobject set-array --ref 'TEST_THING' '.arr' 'test_array'
# bobject get-array --value 'TEST_THING' '.arr'
# echo "${REPLY[@]}"

err_handler() {
  core.print_stacktrace
}
core.trap_add 'err_handler' ERR

main() {
	export VERIFY_BASH_OBJECT=

	local json_file="${0%/*}/file.json"
	local json_text=
	json_text=$(<"$json_file")

	declare -Ag root_value=()
	bash_json.parse 'root_value' "$json_text"
	local root_value_name="$REPLY1"
	local root_value_type="$REPLY2"

	# shellcheck disable=SC2154
	case $root_value_type in
	object)
		printf '%s\n' "Object found ($root_value_type): $root_value_name"
		bobject.print "$root_value_name"
		;;
	array)
		printf '%s\n' "Array found ($root_value_type): $root_value_name"
		bobject.print "$root_value_name"
		;;
	string)
		printf '%s\n' "String found ($root_value_type): $root_value_name"
		;;
	number)
		printf '%s\n' "Number found ($root_value_type): $root_value_name"
		;;
	*)
		core.print_die "Value type did not match: $root_value_type"
		;;
	esac
}

main "$@"

