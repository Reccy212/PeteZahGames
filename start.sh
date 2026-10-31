#!/bin/sh
mkdir -p /app/data
mochi &
exec node backend/server.js
