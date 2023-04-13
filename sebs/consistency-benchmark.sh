#!/usr/bin/env bash
set -e

runOne() {
    platform="$1"
    config="$2"
    name="$3"
    start="$(date +%s)"

    echo "STARTING $platform-$name"
    echo ""
    echo ""

    mkdir -p "perf-cost"

    time python3.8 ./sebs.py experiment invoke perf-cost --config "$config" --deployment "$platform" --verbose

    end="$(date +%s)"

    time python3.8 ./sebs.py experiment process perf-cost --config "$config" --deployment "$platform" --verbose

    mv "perf-cost" "consistent-statistics/$platform-$name-$start-$end"
}

main() {
    mkdir -p "./consistent-statistics"

    # Run the tests forever
    for (( i=0; i>=0; i++))
    do
        echo "Run $i @ $(date) ------------------------------------------------------------------------------"
        echo ""
        echo ""
        runOne gcp config/consistency_gcp_html.json "html"
        runOne aws config/consistency_aws_html.json "html"
        runOne gcp config/consistency_gcp_zip.json "zip"
        echo "Sleeping 1m, good time to exit now..."
        sleep 1m
    done
}

main
