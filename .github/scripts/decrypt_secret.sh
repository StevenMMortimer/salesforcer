#!/bin/sh

# Decrypt the file
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$SALESFORCER_TOKEN_PASSPHRASE" \
--output "$SALESFORCER_TOKEN_PATH"salesforcer_token.rds "$SALESFORCER_TOKEN_PATH"salesforcer_token.rds.gpg
