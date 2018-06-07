import time

sql_server_pnr_list = []
sql_server_pnr_file = open('./file_from_sql_server.csv.example', 'r')
for x in sql_server_pnr_file:
    sql_server_pnr_list.append(x[:10])
sql_server_pnr_file.close()

get_all_filters_pnr_dict = {}
get_all_filters_pnr_file = open('./file_from_soap_ui.txt.example', 'r')
for y in get_all_filters_pnr_file:
    get_all_filters_pnr_dict[y[:10]] = None
get_all_filters_pnr_file.close()

persons_not_subscribed = []

checked = 0
sql_server_pnr_list_length = len(sql_server_pnr_list)
print('Length of SQl Server PNR list: {}'.format(sql_server_pnr_list_length))
time.sleep(2)
for x in sql_server_pnr_list:

    if x not in get_all_filters_pnr_dict:

        subscribe = open('./subscribe.txt', 'a')
        subscribe.write('{}\n'.format(x))

    checked += 1
    sql_server_pnr_list_length -= 1
    print('Countdown: {} Checked: {}'.format(
        str(sql_server_pnr_list_length),
        str(checked))
    )

print('\nDone. See ./subscribe.txt')
