rm -f code.tar.gz chaincode.tgz connection.json metadata.json

CHAINCODE_NAME=asset
CHAINCODE_LABEL=asset

cat << METADATA-EOF > "metadata.json"
{
    "type": "ccaas",
    "label": "${CHAINCODE_LABEL}"
}
METADATA-EOF

cat > "connection.json" <<CONN_EOF
{
  "address": "${CHAINCODE_NAME}:7052",
  "dial_timeout": "10s",
  "tls_required": false
}
CONN_EOF

tar -czf code.tar.gz connection.json
tar -czf chaincode.tgz metadata.json code.tar.gz

PACKAGE_ID=$(kubectl hlf chaincode calculatepackageid --path=chaincode.tgz --language=node --label=$CHAINCODE_LABEL)
echo "PACKAGE_ID=$PACKAGE_ID"
export PACKAGE_ID=$PACKAGE_ID