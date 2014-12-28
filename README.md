# PushNotification Adapter for Node-Linda

under developments

## usage

```
Adapter = require 'linda-pushnotificaiton-adpater'

Linda = require('linda').Client

adapter = new Adapter().connect 'http://YOUR_LINDA_HOST'
linda = new Linda().connect adapter
```
