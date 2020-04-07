clear
echo "Welcome to the Express Server Setup Script by Matt Dittmer (@TipSpy - GitHub)"
echo "This script relies on Node.JS as well as NPM being installed and setup already."
echo "Do you have Node.JS and NPM installed? (y/n)"
read nodeyn
if [ "$nodeyn" != "y" ]; then
    echo "Please install Node.JS and NPM and run the script again."
else
    echo "Perfect. Let's begin."
    echo "First we need a name. What would you like to call this server? (No spaces!):"
    read serverName
    echo "'$serverName'? Sounds awesome."
    echo "Next let's create $serverName's home. Type the path where you would like the folder to be created. (/path/to/destination)"
    echo "This script will create a folder for '$serverName' in the directory you specify."
    echo "Enter the destination path, or CANCEL:"
    read destination
    if [ "$destination" == "CANCEL" ]; then
        echo "CANCELLED! Goodbye!"
    else
        echo "Sweet. Creating $serverName's home ($destination/$serverName) This is where you will find the server files."
        mkdir $destination/$serverName
        mkdir $destination/$serverName/html
        echo "Next I will copy the server files over for you, but first we need a port."
        echo "Enter the port you would like the server to listen on (This can be changed later in server.js):"
        read listenPort
        echo "app.listen($listenPort);" >> server.js
        cp server.js $destination/$serverName/server.js
        echo "Welcome to $serverName's index page!</body></html>" >> index.html
        cp index.html $destination/$serverName/html/index.html
        echo "Next we will install express in $serverName's home."
        npm --prefix $destination/$serverName install express
        echo "Okay, now that we did that, let's make the service."
        echo "Would you like the service to be called '$serverName'? (y/n):"
        read serviceyn
        serviceName="failed"
        if [ "$serviceyn" != "y" ]; then
            echo "Please enter the desired service name (No spaces!):"
            read serviceName
        else
            serviceName=$serverName
        fi
        syslogIden="failed"
        echo "Would you like the Syslog identifier for the service to be '$serverName'? (y/n):"
        read syslogyn
        if [ "$syslogyn" != "y" ]; then
            echo "Please enter the desired syslog identifier (No spaces!):"
            read syslogIden
        else
            syslogIden=$serverName
        fi
        echo "Next we need to create a user for the service."
        echo "Enter the desired username for the service user (No spaces!):"
        read serviceUser
        echo "Creating unix account '$serviceUser'"
        useradd -mrU $serviceUser
        echo "Copying the service file to the systemd directory."
        echo "[Service]
            Type=simple
            ExecStart=/usr/bin/node $destination/$serverName/server.js
            Restart=always
            StandardOutput=syslog
            StandardError=syslog
            SyslogIdentifier=$syslogIden
            User=$serviceUser
            Environment=NODE_ENV=production

            [Install]
            WantedBy=multi-user.target" >> /etc/systemd/system/$serviceName.service
        echo "Would you like to enable and start the service now? (y/n):"
        read enableyn
        if [ "$enableyn" != "y" ]; then
            echo "Okay, you can enable the service manually later by typing 'systemctl enable $serviceName'"
        else
            systemctl enable $serviceName
            systemctl start $serviceName
        fi
        echo "The script is complete! Enjoy your new express server!"
        echo "The server lives at '$destination/$serverName' and the service is called '$serviceName'"
        echo "You can view the test page in a web browser by navigating to this machine's IP address with the port $listenPort (I.E. 127.0.0.1:$listenPort)"
        echo "Thanks for using my script! ~Matt Dittmer (@TipSpy - GitHub)"
    fi
fi