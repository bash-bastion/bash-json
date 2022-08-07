#!/usr/bin/env bats

load './util/init.sh'

@test "Outputs 'foxxy!'" {
	run bash-json.fn

	[ "$status" -eq 0 ]
	[ "$output" = "foxxy!" ]
}
