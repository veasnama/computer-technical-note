# we are going to start by dispaying the text
echo "Starting synchronize the data"
if [ -z "$1" ]
then
    git add .
    git commit -m "Data synchronization complete"
    git push 
else
    git add .
    git commit -m "$1"
    git push 
fi
