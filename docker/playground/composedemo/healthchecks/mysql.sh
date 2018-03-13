
RESULT=`mysqlshow  music| grep -v Wildcard | grep -o album` 
if [ "$RESULT" != "album" ]; then
    echo "MYSQL still down"
    continue
else
    echo "MYSQL IS UP"
    exit 0
fi