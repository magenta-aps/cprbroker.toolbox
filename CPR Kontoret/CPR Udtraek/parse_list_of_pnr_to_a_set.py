##############################################
##### Creating a Set of pnr from n files #####
##############################################

# files = ['exampe_file_01', 'exampe_file_02']

files = ['CprBroker_PersonSearchCache.csv', 'DprEmulering_DTTOTAL.csv']

pnrs = set()

for path in files:

    pnr_file = open(path,'r')

    for line in pnr_file:

        # TODO: CHECK FOR 10 digits!

        # NOTE: Only grabbing 10 first chars, and leaving out the potential '\n'
        format_line = line[0:10]
        pnrs.add(format_line)

    pnr_file.close()

##############################################################
##### Documentation on creating inddata file from 'pnrs' #####
##############################################################

# 
# Source: Nøglestruktur.pdf
# Reference: https://cprdocs.atlassian.net/wiki/spaces/CPR/pages/51158726/N+glestrukturer
#
# Struktur for Personnummer-nøgle :
#
#                   Længde  Startpos
# Inddatatype       2       1           Værdi = 01
# Opgavenr          6       3
# Personnr          10      9
# Nøglekonstant     15      19
# Filler            47      34
#
# Recordlængde 80

#################################################
##### Creating inddata file from 'pnrs' Set #####
#################################################

koerselsdato = '180530' # e.g. 180528
inddatatype = '01'
opgavenummer = '139520' # The tasknr. is defined by CPR Kontoret
noeglekonstant = '               ' 
filler = '                                               '

inddata_filename = 'd{}.i{}'.format(koerselsdato, opgavenummer)
inddata_file = open(inddata_filename, 'a', newline='\n')

for personnr in pnrs:

    inddata_file.write( 
        inddatatype + 
        opgavenummer + 
        personnr + 
        noeglekonstant + 
        filler + 
        '\n'
    )

inddata_file.close()


   