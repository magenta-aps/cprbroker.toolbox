import re

def file_to_set(pnr_file_path):

    pnr_set = set()
    
    pnr_file = open(pnr_file_path, 'r')

    for line in pnr_file:
        
        if len(line) == 11:

            pnr_set.add(line[0:10])

        if len(line) == 10:
            
            pnr_set.add('0{}'.format(line[:9]))

    pnr_file.close()

    return pnr_set


if __name__ == "__main__":
    
    files = ['cprbroker_cpr.csv', 'dpr_cpr.csv']

    list_of_sets = []

    for path in files:

        list_of_sets.append(file_to_set(path))

    pnr_diff_list = list()

    if len(list_of_sets[0]) > len(list_of_sets[1]):

        pnr_diff_list = list(list_of_sets[0] - list_of_sets[1])

    else:

        pnr_diff_list = list(list_of_sets[1] - list_of_sets[0])

    diff_file = open('result.txt', 'a')

    for pnr in pnr_diff_list:

        pnr = '{}\n'.format(pnr)

        diff_file.write(pnr)

    diff_file.close()
