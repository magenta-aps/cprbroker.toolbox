# path = './dÅÅMMDD.l<opgavenr>'
path = ''

su = open(path, 'r')
sux = open(path + '.cpr', 'a', newline='')

for l in su:

    if l[:3] == '001':

        sux.write(l[0:-16] + '\n')

    else:

        sux.write(l)

su.close()
sux.close()
