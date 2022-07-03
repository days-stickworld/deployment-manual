@echo off

:start
color 70
cls
echo Welkom bij DAY's Stickworld!
echo ===========================
echo Voordat dit werkt, geef het IP van de Redis Server op: 
set /p redis=Enter IP: 
echo Geef nu jou eigen publieke IP op:
set /p server=Enter IP: 
echo En tot slot, de naam van je nieuwe server!
set /p serverName=Enter Name: 
echo Als het niet werkt, vergeet niet te portforwarden!
echo 			(Poort 7777)

:serverStart_inDocker
docker run -d -p 7777:7777/udp --name days-stickworld-server -e SERVER_CLUSTER=EU-1 -e SERVER_ID=%serverName% -e REDIS_HOST=%redis% -e SERVER_HOST=%server% -e SERVER_PORT=7777 parrotlync/days-stickworld-linux