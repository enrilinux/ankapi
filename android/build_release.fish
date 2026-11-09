#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
cd "$script_dir/.."

./android/gradlew --stop
if test $status -ne 0
    echo 'Impossibile arrestare il daemon Gradle; build annullata.'
    exit 1
end

read --silent --prompt-str='Password keystore: ' GOKAPI_SIGNING_PASSWORD
echo

if test -z "$GOKAPI_SIGNING_PASSWORD"
    echo 'Password vuota: build annullata.'
    exit 1
end

set -gx GOKAPI_SIGNING_PASSWORD "$GOKAPI_SIGNING_PASSWORD"
set -gx CI 1
flutter build apk --release --split-per-abi --target-platform android-arm,android-arm64
set build_status $status
set -e GOKAPI_SIGNING_PASSWORD
exit $build_status
