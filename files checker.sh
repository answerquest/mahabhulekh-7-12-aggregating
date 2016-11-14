#ADD-ON: file checker, creates a table listing filenames with the 7/12 info from their contents.
# Useful to ensure that you've downloaded the right files and haven't saved same 7/12 under multiple filenames
#(happens when we open more than one 7/12 page at a time)

echo "filename,gat_hissa" > filecheck.csv
for f in *.htm*
do
printf "${f%.*}," >> filecheck.csv
hxnormalize -x -l 2000 $f | hxselect -c 'body > table:nth-child(7) > tbody > tr > td:nth-child(1) > table > tbody > tr:nth-child(2) > td:nth-child(1) > font' >> filecheck.csv
echo >> filecheck.csv
done
