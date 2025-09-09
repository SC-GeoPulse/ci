#!/bin/bash -e

for (( i=1; i<=$#; i++)); do
case ${!i} in
    --state)
    i=$((i+1))
    STATE=${!i}
    ;;
    --description)
    i=$((i+1))
    DESCRIPTION=${!i}
    ;;
    --token)
    i=$((i+1))
    TOKEN=${!i}
    ;;
    --repo)
    i=$((i+1))
    REPO=${!i}
    ;;
    --commit)
    i=$((i+1))
    COMMIT=${!i}
    ;;
    -h|--help)
    echo "Usage: report.sh [options]"
    echo ""
    echo "Options:"
    echo "  --state <STATE>             State to report"
    echo "  --description <DESCRIPTION> Message to report"
    echo "  --token <TOKEN>             GitHub API token to use"
    echo "  --repo <REPOSITORY>         Target repository"
    echo "  --commit <COMMIT SHA>       Target commit"
    echo "  -h|--help                   Display this help message"
    exit 0
    ;;
    *)
            # unknown option
    echo "Unknown option: ${!i}"
    exit 1
    ;;
esac
done

if [ -z "$TOKEN" ]; then
    TOKEN="$GP_GITHUB_TOKEN"
fi

if [ -z "$REPO" ]; then
    REPO="$GP_REPO"
fi

if [ -z "$COMMIT" ]; then
    COMMIT="$GP_COMMIT"
fi

curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    $GITHUB_API_URL/repos/$GITHUB_REPOSITORY_OWNER/$REPO/statuses/$COMMIT \
    -d "
    {
        \"state\": \"$STATE\",
        \"target_url\": \"$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID\",
        \"description\": \"$DESCRIPTION\",
        \"context\": \"$GITHUB_REPOSITORY ($GITHUB_WORKFLOW)\"
    }
    "
