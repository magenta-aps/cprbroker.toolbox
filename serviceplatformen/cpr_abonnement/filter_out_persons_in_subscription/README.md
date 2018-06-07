# Filter out persons in subscription

## What

We want to figure out if there are person numbers in CPR Broker and DPR Emulation that are not in subscription at Serviceplatformen.

## Why

Because all persons in CPR Broker and DPR Emulation must be subscribed to.
If persons are not inserted into DPR Emulation using DPR Emulation Diversion then they will not be put in subscription by CPR Broker. I suspect that this is not uncommon, because it's treated like a normal DPR database by DXC(CSC)-, and perhaps other applications who do not only perform READ-, but also e.g. INSERT and UPDATE.

## how

Export all person numbers from <cpr_broker>.dbo.PersonSearchCache (and <dpr_emulation>.dbo.DTTOTAL) into a collection of person numbers not containing duplicate entries, like so:

**0000000000**<br>
**1111111111**<br>
**2222222222**<br>

It's recommended using the script *cprbroker.toolbox/cpr_kontoret/cpr_udtraek/inddata_file/create_inddata_file/create_inddata_file_based_on_pnr_files.py*. The reason is that there is a list/array in the script for appending *n* paths to pnr files, and it's also able to differentiate between CPR Broker- and DPR Emulation pnr extractions, and parse a given line accordingly.
Afterwards, for each line i the "INDDATA" file you must remove "inddatatype", "opgavenummer", and the remaining white spaces, so each line is as mentioned above.

Now do an extract of person numbers from CPR Abonnement at Serviceplatformen. These can be acquired by using SoapUI to call the CPR Abonnement operation GetAllFilters(). Save the person numbers in a file in the manner.

In *cprbroker.toolbox/serviceplatformen/cpr_abonnement/filter_out_persons_in_subscription/filter_out_persons_in_subscription.py* set the two paths *sql_server_pnr_file* and *get_all_filters_pnr_file*. Run *filter_out_persons_in_subscription.py* and check *cprbroker.toolbox/serviceplatformen/cpr_abonnement/filter_out_persons_in_subscription/* for the file named *subscribe.txt*.
*subscribe.txt* contains the person numbers you want to put in subscription.
