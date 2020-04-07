# Express Server Setup Script

This is a script I decided to create after struggling to find documentation online for setting up an express server as a systemctl service. If you are trying to set up any Node.js server as a systemctl service, not just express, you can still use this script and just move your project to the directory which this script creates, and name your server file 'server.js.'

### Note

I wrote this script mainly for my personal use, and have only tested it on Ubuntu Server 16.04 LTS. It may work for other distros, but I make no promises.

## Getting Started

This script pretty much holds your hand through the process of setting up the server and the service, and does most of the work for you.

## Prerequisites

The script requires NodeJS to be installed as well as NPM.

The service calls /usr/bin/node to start the server, so make sure node lives here. To test, you can use the following command:

```
/usr/bin/node
```

If this command opens the node prompt, you're all set. If not, install NodeJS.


## Using the script

### Pulling this repository and running the script

Create a temporary directory for this repository to live in while you run the script. This should be seperate from your server directory and can be deleted after running the script.

The script needs to be run as root (sudo) as it deals with the /etc/systemd/system directory to create the service.

```
mkdir /express-setup
cd /express-setup
git init
git pull https://github.com/TipSpy/Express-Server-Auto-Setup-Script.git
sudo bash setup.sh
```

### Do you have NodeJS and NPM installed?

First, the script will ask if you have NodeJS and NPM installed. If you did the test above and verified NodeJS is installed, enter 'y'.

```
Do you have Node.JS and NPM installed? (y/n)
y
```

### Server Name

The script will ask for the server name to use for this server.

```
First we need a name. What would you like to call this server? (No spaces!)
test-server
```

### Server Path

The script will ask for the path to create the server at. The path MUST exist!
For example, if we want the server to live in the directory /test, we will enter /test
This will create a directory in /test named whatever you entered as the server name.
, I.E. /test/test-server. You can cancel the script at this point by typing CANCEL if you need to create a directory.

```
This script will create a folder for 'test-server' in the directory you specify.
Enter the destination path, or CANCEL:
/test
```

### Server Port

The script will ask you to specify the port on which the server will listen.
This CAN be changed later by editing server.js in the server directory!

```
Enter the port you would like the server to listen on (This can be changed later in server.js):
3000
```

**NOTE**
If you use a port *BELOW* 1024, this could cause an issue with the service running due to non-root users being dis-allowed to use ports below 1024. If you run into this issue, execute the following command to allow node to use lower ports regardless of the user.
```
sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/node
```

### Service name

The script will ask for the service name and give you the option to make it the same as the server name. Entering 'y' will use the server name, entering 'n' will ask you to specify a service name to use.

The service name will be the systemctl service. (I.E. service serviceName start/stop/status)

```
Would you like the service to be called 'test-server'? (y/n):
y
```
```
Would you like the service to be called 'test-server'? (y/n):
n
Please enter the desired service name (No spaces!):
otherServiceName
```

### Syslog Identifier

The script will ask for the syslog identifier to use for the service and give you the option to make it the same as the server name. This is the identifier that will show in the syslog for messages from the service.Entering 'y' will use the server name, entering 'n' will ask you to specify a service name to use.

```
Would you like the Syslog identifier for the service to be 'test-server'? (y/n):
y
```
```
Would you like the Syslog identifier for the service to be 'test-server'? (y/n):
n
Please enter the desired syslog identifier (No spaces!):
otherSyslogIdentifierHere
```

### Service User

The script will ask you to specify a username for the user account that will run the service. If you already have a user created for this, enter that username. If not, enter a username to create.

**THIS CREATES A UNIX USER!**

```
Enter the desired username for the service user (No spaces!):
test-user
```

### Enabling the service

To finish, the script will ask if you want to enable the service.

```
Would you like to enable and start the service now? (y/n):
y
```
```
Would you like to enable and start the service now? (y/n):
n
Okay, you can enable the service manually later by typing 'systemctl enable test-service'
```

**NOTE**
If you used a port *BELOW* 1024, I recommend **NOT** enabling the service until you run the command as mentioned in the "Server Port" section, or else the service will fail to start and require a reset.

If you made this mistake, you can reset the service by running this command
```
systemctl reset-failed
service serviceName start
```

## Using the server

### Opening the test page

After running the script and enabling the service, the server will be hosting a test page. Open a web browser and navigate to the test page by entering the ip of your server followed by the port you specified:

```
xxx.xxx.xxx.xxx:3000
```

### Editing the server

The server will live at the directory you specified, and you can edit the server.js file to perform as you wish.

**NOTE**
Any changes made to server.js will *NOT* be made live until you run the command below. Changes to hosted files in the html directory will be made live without running the command.

```
service serviceName restart
```

## Troubleshooting

If the server does not start after enabling the service and starting the service, run the following command to help understand what went wrong.

```
service serviceName status
```

If you require more help, please post the contents returned by the command above and create an issue on this repository and i will try to help you to the best of my ability. **Please try google first!**

## Authors

* **Matt Dittmer** - *Automation Script* - [TipSpy](https://github.com/TipSpy)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details