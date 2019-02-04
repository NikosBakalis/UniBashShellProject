# BashShell
School Project. Create a Shell Script that allows you to work with a database on terminal.
Working with the "dates.dat" (database) file.
Get info using terminal from this database.


Commands on terminal:
./tool.sh
./tool.sh -f <filename>
./tool.sh -f <filename> -id <ID>
./tool.sh -f <filename> --firstnames
./tool.sh -f <filename> --lastnames
./tool.sh -f <filename> --born-since <dateA> --born-until <dateB>
./tool.sh -f <filename> --socialmedia
./tool.sh -f <filename> --edit <ID> <column> <value>


You can also give the parameters by any order.
For example the following are identical:
./tool.sh --born-since <dateA> --born-until <dateB> -f <filename>
./tool.sh --born-until <dateB> -f <filename> --born-since <dateA>
./tool.sh –f <filename> --born-until <dateB> --born-since <dateA>
./tool.sh –f <filename> --born-since <dateA> --born-until <dateB>
