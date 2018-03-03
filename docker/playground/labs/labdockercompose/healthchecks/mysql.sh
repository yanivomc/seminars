
RESULT=`mysqlshow  music| grep -v Wildcard | grep -o album` 
if [ "$RESULT" != "album" ]; then
    echo "MYSQL still down"
    exit 1
else
    echo "MYSQL IS UP"
fi