#!/usr/bin/env bash

mkdir uploads
sqlite3 listenin.db < models/schemas/sqlite.sql
