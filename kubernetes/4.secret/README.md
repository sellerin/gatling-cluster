Replace {{username}} {{password}} with github credentials

https://kubernetes.io/docs/concepts/configuration/secret/

echo -n "username" | base64 -w 0
echo -n "password" | base64 -w 0