#!/bin/bash

git clone -b $BRANCH "https://$GIT_USERNAME:$GIT_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git" "$BITBUCKET_COMMIT"

git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USERNAME"

cd "${BITBUCKET_COMMIT}"
echo $IMAGE_BRANCH_TAG

if [[ "$BITBUCKET_BRANCH" == "develop" ]] || [[ "$BITBUCKET_BRANCH" == "dev" ]]; then
        HELM_VALUE="$DEFAULT_HELM_PATH/dev.yaml"
        sed -i "s|tag: .*|tag: $IMAGE_BRANCH_TAG|" $HELM_VALUE
    elif [[ "$BITBUCKET_BRANCH" == "qa" ]]; then
        HELM_VALUE="$DEFAULT_HELM_PATH/qa.yaml"
        sed -i "s|tag: .*|tag: $IMAGE_BRANCH_TAG|" $HELM_VALUE
    elif [[ "$BITBUCKET_BRANCH" == "uat" ]]; then
        HELM_VALUE="$DEFAULT_HELM_PATH/uat.yaml"
        sed -i "s|tag: .*|tag: $IMAGE_BRANCH_TAG|" $HELM_VALUE
    elif [[ "$BITBUCKET_BRANCH" == "main" ]] || [[ "$BITBUCKET_BRANCH" == "master" ]] ; then
        HELM_VALUE="$DEFAULT_HELM_PATH/prod.yaml"
        search_value="*$DEFAULT_HELM_PATH"
        found_files_prod=$(find $search_value -type f -name '*prod*')
        for file in $found_files_prod; do
            file_path=$(basename "$file")
            echo $file_path
            sed -i "s|tag: .*|tag: $IMAGE_BRANCH_TAG|" "$DEFAULT_HELM_PATH/$file_path"
        done
else
    HELM_VALUE="$DEFAULT_HELM_PATH/dev.yaml"
    sed -i "s|tag: .*|tag: $IMAGE_BRANCH_TAG|" $HELM_VALUE
fi


git add .

MAX_RETRIES=5
RETRY_COUNT=0
GIT_PUSH_COMMAND="git push origin $BRANCH"
GIT_PULL_COMMAND="git pull origin $BRANCH --no-rebase"
GIT_MERGE_COMMAND="git merge $BRANCH"
SLEEP_INTERVAL=10
GIT_SLEEP_INTERVAL=$(( ( RANDOM % 5 )  + 1 ))

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do

    git commit -am "[🚀]: Change tag image $HELM_VALUE to $IMAGE_BRANCH_TAG"
    result=$($GIT_PUSH_COMMAND || echo "False")

    if [ "$result" == "False" ]; then
        echo "Git push failed (Attempt $((RETRY_COUNT+1)) of $MAX_RETRIES)"
        RETRY_COUNT=$((RETRY_COUNT+1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo "A gap between two push, let's pull and retry"
            $GIT_PULL_COMMAND
            echo "Retrying in $SLEEP_INTERVAL seconds..."
            sleep $SLEEP_INTERVAL
        else
            result_merge=$($GIT_MERGE_COMMAND || echo "False")
            if [ "$result_merge" == "False" ]; then
                echo "Max retries reached. Exiting..."
                exit 1
            else
                exit 0
            fi
        fi
    else
        break
        echo "Git push successful!"
        exit 0
    fi
done