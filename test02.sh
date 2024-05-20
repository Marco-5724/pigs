#! /bin/dash

# this test will check if the pigs-commit works correctly

PATH="$PATH:$(pwd)"

# create a temporary directory for the test.
test_dir=$(mktemp -d)
cd "$test_dir" || exit 1

# create some files to hold output.
expected_output=$(mktemp)
actual_output=$(mktemp)


# remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# create pigs repository
cat >"$expected_output" <<EOF
pigs-commit: error: pigs repository directory .pig not found
Initialized empty pigs repository in .pig
Committed as commit 0
nothing to commit
EOF

{
    pigs-commit
    pigs-init
    echo 1 >a
    pigs-add a
    echo 3 >a
    pigs-commit -m 'first commit'
    pigs-commit -m 'second commit'
} >"$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "failed"
    exit 1
else
    echo "pass"
    exit 0
fi
