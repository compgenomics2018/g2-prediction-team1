# Give the tool name as an argument. Can update the name later as needed.
tool=$1;

for file in *.gff; do
    base=`echo $file | awk -F'[/./_]' '{print $1}'`;
    echo $base;
    echo $file;
    echo "$base"_"$tool".gff;
    mv $file "$base"_"$tool".gff;
done