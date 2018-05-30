# 'Statusudtræk' based on 'personnummernøgler'

## File name format

Inddatafiler have a naming standard, e.g. ÅÅMMDD.iNNNNNN
ÅÅMMDD( ÅÅ <=> YY ) is the date which to process the file (the file must be uploaded to the '/ind' folder on the FTP server weekdays before 12.00pm).
NNNNNN is the task number for the task, for which the file is related to.

You can read more about the different ind- and outdata formats here: https://cprdocs.atlassian.net/wiki/spaces/CPR/pages/51158404/Ind-+og+uddatafiler

## Line format in the inddata file

Each line of in the inddata file is a definition of a given person you want to include in the 'Statusudtraek'.
There are several other values that need to be included in each line. The table describes how a line has to be structured.

*source: https://cprdocs.atlassian.net/wiki/spaces/CPR/pages/51158726/N+glestrukturer/Nøglestrukturer.pdf*

### Struktur for Personnummernøgle :###

| Description   | Length        | Start position  | 
| ------------- |:-------------:| ---------------:|
| Inddatatype   | 2             | 1               | 
| Opgavenr      | 6             | 3               |
| Personnr      | 10            | 9               | 
| Nøglekonstant | 15            | 19              | 
| Filler        | 47            | 34              |

Recordlaengde = 80

Inddatatype for Personnummerøgle = 01

## Script

**create_inddata_fle_based_on_pnr_files.py**

You will need to set the path(s) to the pnr file(s) inside the script before running it.
The inddata file will be outputtet in the same folder as the script; or wherever you define the output path.


