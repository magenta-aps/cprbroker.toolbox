import re


__author__ = "Heini Leander Ovason"

""" NOTE: The example files indicate the expected format.
They are simulating extracts from CPR Broker' PersonSearchCache,
and DPR EMulation' DTTOTAL."""
files = ['exampe_file_01', 'exampe_file_02']

# Solely for avoiding duplicate pnr entries.
pnr_set = set()

for path in files:

    pnr_file = open(path,'r')

    for line in pnr_file:

        check_line = re.match(r'^\d{10}$', line)

        if check_line:
            
            # leave out potential '\n'
            formatted_line = line[0:10]

            pnr_set.add(formatted_line)

        """If the line is 9 digits, and the file contains person numbers 
        from a DprEmulering.dbo.DTTOTAL then there will not be any
        leading zeros. This is because a person number is of type
        int the DPR data model."""
        check_for_dpr_format = re.match(r'^\d{9}$', line)

        if check_for_dpr_format:

            # Prepend a zero and leave out potential '\n'
            formatted_dpr_line = '0{}'.format(line[:9])

            pnr_set.add(formatted_dpr_line)
        

    pnr_file.close()

# Convert to list
pnr_list = list(pnr_set)

# It is a requirement that the list is naturally sorted.
pnr_list.sort()

""" NOTE: CPR Udtraek docs. specify that charset should 
be ISO-8859-1 (ASCII), but this should not matter if we 
are only using alphanumerical values """

koerselsdato = '180530' # e.g. 180528
inddatatype = '01'
opgavenummer = '114352' # The tasknr. is defined by CPR Kontoret
noeglekonstant = '               ' 
filler = '                                               '

inddata_filename = 'd{}.i{}'.format(koerselsdato, opgavenummer)
inddata_file = open(inddata_filename, 'a')

for personnr in pnr_list:

    inddata_person = '{}{}{}{}{}\n'.format(
                                            inddatatype,
                                            opgavenummer, 
                                            personnr,
                                            noeglekonstant,
                                            filler
                                            )

    inddata_file.write(inddata_person)

inddata_file.close()


   