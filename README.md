# mahabhulekh-7-12-aggregating
Shell scripts to aggregate data from a folder of 7/12 (saat-baara) pages downloaded from Mahabhulekh (MH land records portal)

Note: Do this on Ubuntu / similar operating system.

### Commands that might require installing some packages first:
hxnormalize, hxselect ([read more](http://www.joyofdata.de/blog/using-linux-shell-web-scraping/))<br>
`sudo apt-get install html-xml-utils`

tidy<br>
`sudo apt-get install tidy`

## Instructions
- Download your 7/12s (open from website and press Ctrl+S or Command+S, save as HTML-only) to a common folder.
  - If multiple gats, then i advise you name them like 1_2.html , 1_2.html etc for 1/1, 1/2
- Save the `tablescrape.py` script there too. Oh, and make sure python is installed at your end!
- Open the Terminal (Ctrl+Alt+T) and bring it to the working folder.
- Open main script.sh file in a text editor. I suggest not to run it directly in the terminal.
- Copy-paste the lines to the terminal, press `Enter` if it's at the last line and hasn't executed it.
- You'll see some new csv's created in your folder. Open them and inspect if done propery.

## Troubleshooting
Use the script in `files checker.sh` file to create an excel listing the files and the gat/hissa numbers inside them.
