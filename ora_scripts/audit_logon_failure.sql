audit session whenever not successful;

find . -name "*.aud" -mmin -60 -exec grep -i "1017" {} \; | grep -i siebel