tr '\n' ' ' < union.txt > union1.txt
sed -i "s/^ *//;s/ *$//;s/ \{1,\}/ /g" union1.txt
echo -e ";\n" >>union1.txt
LINE_NUMBER=`grep -n "union all" union1.txt | cut -f1 -d: | tail -1`
PATERN_NUMBER=`sed 's/union all/union all\n/g' union1.txt | grep -c "union all"`
sed -i " $LINE_NUMBER s/union all/ /${PATERN_NUMBER}g" union1.txt 
PAT="union all"
sed -i 's/union all/\n&/g' union1.txt
sed -i 's/union all/&\n/g' union1.txt


