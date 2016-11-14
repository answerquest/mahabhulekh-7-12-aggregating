# pre-create the headers for saatbaranames and saatbarainfo :
echo "key,gat,hissa,serial,head or descendant,भोगवटदाराचे नांव,क्षेत्र,आकार,आणे,पै,पो.ख.,फे.फा,deceased" > saatbaranames.csv
echo "key,गट क्रमांक व उपविभाग,भुधारणा पद्धती,gat,hissa,क्षेत्र एकक,जिरायत,बागायत,तरी,वरकस,इतर,filler,एकुण क्षेत्र,filler,filler,filler,वर्ग (अ),वर्ग (ब),एकुण पो ख,filler,आकारणी,filler,जुडी किवा विशेष आकारणी,filler,खाते क्रमांक,number in खाते क्रमांक,fer-far summary" > saatbarainfo.csv

# now the loop that does the actual job
for f in *.htm*
do
echo "Scraping from $f"

# create variable 
namepath='body > table:nth-child(7) > tbody > tr > td:nth-child(1) > table > tbody > tr:nth-child(2) > td:nth-child(1) > font'
gat=`hxnormalize -x -l 2000 $f | hxselect -c $namepath | cut -d'/' -f1 | tr -d '\n'`
hissa=`hxnormalize -x -l 2000 $f | hxselect -c $namepath| cut -d'/' -f2- | tr -d '\n'`

# table 3, going into saatbaranames.csv
table3='body > table:nth-child(9) > tbody > tr > td > table > tbody > tr:nth-child(1) > td:nth-child(2) > table > tbody'
# alternative table3='body > table:nth-child(9) > tbody > tr:nth-child(1) > td:nth-child(2) > table > tbody'

hxnormalize -x -l 2000 $f   `# normalize HTML, keep large line width` \
| hxselect -c $table3 `# take innerHTML of table 3` \
| sed -e 's/<font face="Sakal Marathi Normal" size="2">//g' \
-e 's/<\/font>//g' \
-e 's/&nbsp;<\/td>/<\/td>/g' \
-e 's/<td align="[A-Za-z]*" valign="top" width="[0-9][0-9]*%">/<td>/g' \
| tidy -utf8 \
| tail -n +10 \
| head -n -3 \
| tr -d '\n' \
| sed -e 's/<\/tr>/<\/tr>\
/g' \
-e 's/<tr><td>//g' \
-e 's/<\/td><\/tr>//g' \
-e 's/<\/td><td>/,/g' \
| grep -v '^,,,,,,$' \
| grep -v '^&nbsp;,' \
| sed -e 's/&nbsp;&nbsp;/descendant,/g' \
-e 's/<\/b>//g' \
-e 's/^<b>/head,/g' \
-e 's/<b>//g'  \
| awk -v var="${f%.*},$gat,$hissa" '{ print var "," FNR "," $0 }' \
| awk -F "," '{ if (substr($6,1,1)=="[") print $0 ",deceased"; else print $0 "," }' | sed -e "s/\[ //g" -e "s/\],/,/g" `# set last column deceased if name starts with [, replace []` \
 >> saatbaranames.csv

# table 1:
table1='body > table:nth-child(7) > tbody > tr > td:nth-child(1) > table'

hxnormalize -x -l 2000 $f \
| hxselect $table1 \
| ./tablescrape.py \
| sed -n 2,2p \
| sed -e "s/^/${f%.*},/g" \
| tr -d '\r\n' \
>> saatbarainfo.csv
printf "," >> saatbarainfo.csv

#############################
# extracting gat and hissa info into separate columns:
printf "$gat,$hissa," >> saatbarainfo.csv

#############################
# table 2:
table2='body > table:nth-child(9) > tbody > tr > td > table > tbody > tr:nth-child(1) > td:nth-child(1) > table'
# alternative table2='body > table:nth-child(9) > tbody > tr:nth-child(1) > td:nth-child(1) > table'

hxnormalize -x -l 2000 $f \
| hxselect $table2 \
| sed -e 's/&nbsp;//g' \
| ./tablescrape.py \
| grep -v "\"\"" \
| cut -d',' -f2 \
| tr -s '\r\n' ',' \
| sed -e "s/-,/0,/g" \
>> saatbarainfo.csv
# ends with a comma so no need to add another

#############################
# table 4:
table4='body > table:nth-child(9) > tbody > tr > td > table > tbody > tr:nth-child(1) > td:nth-child(3) > font'
#alternative table4='body > table:nth-child(9) > tbody > tr:nth-child(1) > td:nth-child(3) > font'

hxnormalize -x -l 2000 $f \
| hxselect -c $table4 \
| sed -e 's/            //g' | tr -d '\n' \
| sed -e 's/&nbsp;&nbsp;/\|/g' \
-e 's/&nbsp;//g' \
-e 's/<\/b>//g' \
-e 's/, /,/g' \
| awk '{ printf "\"" $0 "\"" }' \
| awk -F "|" '{ printf $0 "," "\"" $2 "\""}' \
| sed -e "s/\"<b>कुळाचे नाव\"//g" \
| sed -e "s/<br\/>//g" \
>> saatbarainfo.csv
printf "," >> saatbarainfo.csv #end with comma

#############################
# table 5:
table5='body > table:nth-child(9) > tbody > tr > td > table > tbody > tr:nth-child(2) > td:nth-child(2) > font'
# alternative table5='body > table:nth-child(9) > tbody > tr:nth-child(2) > td:nth-child(2) > font'

hxnormalize -x -l 2000 $f \
| hxselect -c $table5 \
| sed -e 's/&nbsp;//g' \
-e 's/,/\|/g' \
-e 's/[()]//g' \
>> saatbarainfo.csv
# newline:
echo >> saatbarainfo.csv

#############################
done
