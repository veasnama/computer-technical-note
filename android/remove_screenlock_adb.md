# How to remove screen lock with ADB command 
```
echo "rm /data/system/gesture.key" | sudo waydroid shell
then restart it
waydroid session stop
waydroid show-full-ui
```
