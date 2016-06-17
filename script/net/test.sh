http=$(curl -sL --connect-timeout 10 -w "%{http_code} %{url_effective}\\n" $1 -o /dev/null)
curl -sL --connect-timeout 10 -w "%{http_code} %{url_effective}\\n" $1 -o /dev/null
if [ "$?" = "7" ]; then 
  echo 'connection refused or cant connect to server/proxy';
  printf "%-11s %s %s\n" "NO RESPONSE" ${http}
else
  echo 'ok';
  printf "%-11s %s %s\n" "OK" ${http}
fi
