#!/bin/bash
kubectl exec -it testcurl -- sh

curl --location --request POST 'http://keycloak.iam/realms/bets/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'client_id=kong' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'username=rodrigo' \
--data-urlencode 'password=123456' \
--data-urlencode 'client_secret=Mq0WIyGRnumtnXdWl9q16SI9y55YBy40' \
--data-urlencode 'scope=openid'
