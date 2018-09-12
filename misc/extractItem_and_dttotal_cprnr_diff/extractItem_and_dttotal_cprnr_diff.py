import re


__author__ = "Heini Leander Ovason"

""" NOTE: The example files indicate the expected format.
They are simulating extracts from CPR Broker' PersonSearchCache,
and DPR EMulation' DTTOTAL."""
files = ['exampe_file_01', 'exampe_file_02']

# To avoid duplicate pnr entries.
pnr_set = set()

for path in files:

    pnr_file = open(path, 'r')

    for line in pnr_file:

        check_line = re.match(r'^\d{10}$', line)

        if check_line:

            formatted_line = line[0:10]

            pnr_set.add(formatted_line)

        """If the line is 9 digits, and the file contains person number
        from a DprEmulering.dbo.DTTOTAL then there will not be any
        leading zeros. This is because a person number is of type
        int the DPR data model."""
        check_for_dpr_format = re.match(r'^\d{9}$', line)

        if check_for_dpr_format:

            # Prepend a zero and leave out potential '\n'
            formatted_dpr_line = '0{}'.format(line[:9])

            pnr_set.add(formatted_dpr_line)

    pnr_file.close()

pnr_list = list(pnr_set)

""" It is a requirement that the inddata lines are sorted are naturally
sorted. """

pnr_list.sort()

inddata_filename = 'extractItem_and_dttotal_cprnr_diff.txt'
inddata_file = open(inddata_filename, 'a')

for personnr in pnr_list:

    cprnr = '{}\n'.format(personnr)

    inddata_file.write(cprnr)

inddata_file.close()
