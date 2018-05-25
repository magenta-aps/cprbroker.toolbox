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


   