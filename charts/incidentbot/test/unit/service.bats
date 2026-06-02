#!/usr/bin/env bats

load _helpers

#--------------------------------------------------------------------
# Service

@test "service: not created by default" {
    cd $(chart_dir)
    local actual=$(helm template \
        . | yq ea '[select(.kind == "Service")] | length' -)
    [ "${actual}" = "0" ]
}

@test "service: creates when enabled" {
    cd $(chart_dir)
    local actual=$(helm template \
        --set 'service.enabled=true' \
        . | yq ea '[select(.kind == "Service")] | length' -)
    [ "${actual}" = "1" ]
}
