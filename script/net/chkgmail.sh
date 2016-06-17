curl -u acc4itc@gmail.com:4cc41tcw1 --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p"

echo > getemail.xml
curl -u acc4itc@gmail.com:4cc41tcw1 --silent "https://mail.google.com/mail/feed/atom" > getemail.xml
awk -vRS="</title>" '{gsub(/.*<entry><title.*>/,"");print}' getemail.xml

xmllint --xpath "//*[local-name()='title']" getemail.xml

gmail_username='acc4itc'
gmail_atom_url='https://mail.google.com/mail/feed/atom'


curl -u ${gmail_username}@gmail.com:${gmail_password} --silent "$gmail_atom_url"
curl -u ${gmail_username}@gmail.com:${gmail_password} --silent "$gmail_atom_url" | grep -oPm1 "(?<=<title>)[^<]+" | sed '1d' | sed '/./='

curl -u acc4itc@gmail.com:4cc41tcw1 --silent "https://mail.google.com/mail/feed/atom" |  grep -oPm1 "(?<=<title>)[^<]+" | sed '1d'


curl -u ${gmail_username}@gmail.com:${gmail_password} --silent "$gmail_atom_url" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 SUBJ \1/p"


curl -u ${gmail_username}@gmail.com:${gmail_password} --silent "$gmail_atom_url" | grep -oPm1 '(?<=<title>)(?!Gmail)[^<]+'

curl -u ${gmail_username}@gmail.com:${gmail_password} --silent "$gmail_atom_url" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*modified>\(.*\)<\/modified>.*/\2 SUBJ \1/p"

sed -n "s/<title>\(.*\)<\/title.*modified>\(.*\)<\/modified>.*/\2 SUBJ \1/p"


curl -u ${gmail_username}@gmail.com:${gmail_password} --silent "$gmail_atom_url" | grep -oPm1 '(?<=<title>)(?!Gmail)[^<]+'
