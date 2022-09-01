> ## Please reboot your system with reboot command or init 6
> 1. Reboot
![Reboot screenshot of oracle linux ](https://www.rainingforks.com/wp-content/uploads/2016/05/oel1.gif)

> 2. Change boot configuration

- Press the “e” key on the top line of the menu, and then on the next screen that appears, scroll down to the line that starts with “linux16” and  change the end from “…quiet LANG…” to “…quiet rw init=/bin/bash LANG…” so it’ll look like this

![change selected item ](https://www.rainingforks.com/wp-content/uploads/2016/05/oel2.gif)

- ** Note **
- Note: It’s fine if you don’t see the “LANG…” part after “…quiet”  just put the “rw init=/bin/bash” after “quiet” anyway.)

> 3. At the prompt that appears, type “passwd” to change the root password

![image location](https://www.rainingforks.com/wp-content/uploads/2016/05/oel3.gif)

> 4. Now, depending on how your system is configured, you may also need to type 

```
# touch ./autorelabel
```
> 5. ype “/usr/sbin/reboot –f” to reboot

> 6. After waiting a few minutes for the reboot to finish, you should be able to log in as root with your new password!

