sudo puppet agent -t --server=puppetmaster.edureka.com
case $? in
0) echo "All OK" ; exit 0;
   ;;
2) echo "Some Changes made "; exit 0;
   ;;
4) echo "Failed to make changes"; exit 1;
   ;;
6) echo "Some changes made and some failed. check your log"; exit 2;
   ;;
*) echo "Unknown status"; exit 3;
esac
echo "All done"

