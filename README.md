# SafariTabBar

This is a simplistic recreation of the classic MobileSafari tab bar on iPad and visionOS. It is very unfinished, and **not** intended in any way to be a usable control or library in your apps. I'm providing this as illustrative sample code just because it's kinda neat.

This code also demonstrates how you might drag a tab out into a new window on iPad, using NSUserActivity.

### Issues

- There is no logic to provide an overflow menu when there are too many tabs onscreen.
- The way the tab layout is implemented hinders the ability to animate tab transitions
- I would do the top toolbar a different way, if I were implementing this in a real app
- Newly spawned windows via drag & drop are generated with fresh tabs, not actually presenting the tab that was dragged

### Screenshots

![https://hccdata.s3.us-east-1.amazonaws.com/gh_safaritabbar.jpg](https://hccdata.s3.us-east-1.amazonaws.com/gh_safaritabbar.jpg)
![https://hccdata.s3.us-east-1.amazonaws.com/gh_safaritabbar_2.jpg](https://hccdata.s3.us-east-1.amazonaws.com/gh_safaritabbar_3.jpg)
