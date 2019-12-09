#!/bin/ash
REPO_DIR="$(pwd)"            #/github/workspace
DEPLOY_DIR="$REPO_DIR/build" #/github/workspace/build
ARTIFACT_PREFIX="ARTIFACTS:"

echo "Creating deploy directory: $DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"

echo "<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8" />
    <title>$GITHUB_REPOSITORY</title>
</head>
<body>
    <h1>$GITHUB_REPOSITORY</h1>
    <ul>" > $DEPLOY_DIR/index.html

pwd
for directory in */; do

    if [[ $directory == *"build/" ]]; then
        continue
    fi
    
    pwd
    echo "Building $directory"
    cd $REPO_DIR/$directory
    pwd
    mkdir -p $REPO_DIR/$directory
    #ARTIFACTS=$(make | grep "$ARTIFACT_PREFIX")
    #ARTIFACTS=${ARTIFACTS#"$ARTIFACT_PREFIX"}

    latexmk -output-directory=$DEPLOY_DIR/$directory
    # Remove every output that isn't a PDF
    find $REPO_DIR/$directory -type f ! -name "*.pdf" -exec rm {} \;
    ARTIFACTS=$(find $REPO_DIR/$directory -type f -name "*.pdf")
    ARTIFACTS=$(basename "$ARTIFACTS")
    echo "Build artifacts: $ARTIFACTS"

    #for artifact in $(echo $ARTIFACTS | sed "s/,/ /g"); do
    #    mkdir -p $(dirname "$DEPLOY_DIR/$directory/$artifact")
    #    cp "$REPO_DIR/$directory/$artifact" "$DEPLOY_DIR/$directory/$artifact"
    #    echo "        <li><a href=\"$directory$artifact\">$directory$artifact</a></li>" >> $DEPLOY_DIR/index.html
    echo "        <li><a href=\"$directory$ARTIFACTS\">$directory$ARTIFACTS</a></li>" >> $DEPLOY_DIR/index.html
done

echo "    </ul>
</body>
</html>" >> $DEPLOY_DIR/index.html
