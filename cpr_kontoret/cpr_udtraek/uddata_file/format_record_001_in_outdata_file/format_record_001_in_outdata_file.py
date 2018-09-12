# path = './dÅÅMMDD.l<opgavenr>'
path = './d180719.l463003'

su = open(path, 'r')
sux = open(path + '.rdy', 'a', newline='')

for l in su:

    if l[:3] == '001':

        sux.write(l[0:-16] + '\n')

    else:

        sux.write(l)

su.close()
sux.close()
