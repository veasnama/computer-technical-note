> 1. Before we remove the disk make sure to offline the disk or devices , next we could remove it from the disk backplane. 

> 2. Make sure that storage zpool needs to be online 

> 3. Identify the failed disk by looking at the warning sign on the disk of its backplane 
> 4. Find the failed disk id in its pool
> 5. List all of available disk devices on the system with the following command : 

```
echo | format -e
```

- Show pool status
```
# zpool status 
```
- option -v is used to show the health of the pool


- Next replace the old disk by new one
```
# zpool replace pool-name old-disk new-disk
```