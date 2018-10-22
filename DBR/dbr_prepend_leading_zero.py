import re

path_to_file = 'pers_dpr_emu_uden_vejkod.csv'

pnr_list = list()

pnr_file = open(path_to_file, 'r')

for line in pnr_file:

    check_line = re.match(r'^\d{10}$', line)

    if check_line:

        formatted_line = line[0:10]

        pnr_list.append(formatted_line)

    """If the line is 9 digits we have identified a PNR
    that begins with zero; except that the zero has been removed
    due to a person number being of type int the DPR data model."""
    check_for_dpr_format = re.match(r'^\d{9}$', line)

    if check_for_dpr_format:

        formatted_dpr_line = '0{}'.format(line[:9])

        pnr_list.append(formatted_dpr_line)

pnr_file.close()

list_len = len(pnr_list)
print('INPUT(list Length): {}'.format(str(list_len)))

formatted_file = open('formatted_file.csv', 'a')

counter = 0
for personnr in pnr_list:

    inddata_person = '{};'.format(personnr)
    formatted_file.write(inddata_person)
    counter+=1

print('OUTPUT(Persons added to file): {} '.format(str(counter)))

if(list_len==counter):
    print("Number of input persons matches number of persons in output.")
else:
    print("Number of input persons >>> DID NOT <<< match number of persons in output.")

formatted_file.close()

        

       