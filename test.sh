#!/usr/bin/env bash

COMMAND="node index.js"

$COMMAND

$COMMAND --version

$COMMAND --help

node -e "require('babel-core/register'); require('./test/server').default(4002);" &
SERVER_PID=$!

echo "No JS error"
$COMMAND http://localhost:4002/no-error
CODE=$?
echo $CODE
if [ $CODE -ne 0 ];
then
    exit 1;
fi

echo "JS error"
$COMMAND http://localhost:4002/error
CODE=$?
echo $CODE
if [ $CODE -ne 2 ];
then
    exit 1;
fi

echo "Load error"
$COMMAND http://localhost:9999/notfound
CODE=$?
echo $CODE
if [ $CODE -ne 1 ];
then
    exit 1;
fi

echo "No immediate JS error"
$COMMAND http://localhost:4002/error-wait
CODE=$?
echo $CODE
if [ $CODE -ne 0 ];
then
    exit 1;
fi

echo "JS error after 2500ms wait"
$COMMAND http://localhost:4002/error-wait --wait 2500
CODE=$?
echo $CODE
if [ $CODE -ne 2 ];
then
    exit 1;
fi

kill $SERVER_PID
