# fw-client-setup-scripts

These scripts aim to automatically setup the working environment on the ElevationFW/ClientApp.

They ask you want to do:
* Run `npm install`?
    * Run `npm install` in forced mode?
    * Run `npm install` only for @primavera/@prototype dependencies?
* Run `npm update`?
* Run linting?
* Run build?
* Run tests?

<!-- They always redial your `vpn_primavera` at the start to make sure you have it running properly. -->

**They ALWAYS delete the `dist` folder at startup**. If you need it, select the option to `Run build`.

---

## Index
1. [ElevationFW](#elevationfw)
2. [ClientApp](#clientapp)
3. [ValueKeep](#valuekeep)
##### *[↑ Go to top](#fw-client-setup-scripts)*

---
## ElevationFW

Place the script `setup_fw.bat` inside the ElevationJS folder and run it.

<!-- The script will open a console in Administrator mode so it can automatically change to the correct npmrc [*set on `line 11` of the script*]. -->

Every option chosen will run for **every** module in the following order:

```
1. services
2. localization
3. themes
4. components
5. search
6. ngcore
7. pushnotifications
8. attachments
9. dashboard
10. extensibility
11. notifications
12. printing
13. qbuilder
14. shell
```

The `node_modules` deletion will be faster than deleting from the Windows Explorer.

##### *[↑ Go to top](#fw-client-setup-scripts)*
---
## ClientApp

Place the script `setup_clientapp.bat` inside the ClientApp folder and run it.

If you select the option to run `npm install` it will automatically delete the `node_modules` before running `npm install`.

The `node_modules` deletion will be faster than deleting from the Windows Explorer.

##### *[↑ Go to top](#fw-client-setup-scripts)*
---
## ValueKeep

Place the script `setup_vk_modules.bat` inside the ClientModules folder and run it.

<!-- The script will open a console in Administrator mode so it can automatically change to the correct npmrc [*set on `line 11` of the script*]. -->

Every option chosen will run for **every** module in the following order:

```
1. ngbusinesscore
2. ngmaintenance
3. ngplanner
4. vkplanner
5. webcomponents
```

The `node_modules` deletion will be faster than deleting from the Windows Explorer.

##### *[↑ Go to top](#fw-client-setup-scripts)*
---
##### *Review date: 12/04/2023*
##### *Tiago Eusébio @ TOEC*
##### *© PRIMAVERA BSS*