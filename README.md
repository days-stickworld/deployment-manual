# Handleiding Deployment
> Handleiding voor de deployment van het DAY's Stickworld Proof of Concept

Om een functionerende infrastructuur op te zetten voor DAY's Stickworld zijn er een viertal componenten nodig. De gehoste componenten kunnen gemakkelijk in docker gedraaid worden. Hieronder een overzicht van de componenten en een korte beschrijving hiervan:
- **Orchestrator:** De orchestrator monitort alle game servers en zorgt ervoor dat servers op- en afgeschaald kunnen worden.
- **Game server:** De game server zorgt ervoor dat clients kunnen verbinden en elkaar kunnen zien.
- **Redis:** Redis is nodig om de communicatie tussen orchestrator en server te kunnen faciliteren.
- **Game client:** De game client draait lokaal bij de gebruiker. Dit is het daadwerkelijke spel.

### Deployment van de infrastructuur
> :warning: **Let op**: Voor de deployment gaan we ervan uit dat er een **docker** omgeving beschikbaar is. Voor meer informatie omtrent docker, [klik hier](https://docs.docker.com/).

De docker containers van de gehoste componenten zijn te vinden in de bijbehorende repositories, onder "packages". Hieronder is een docker-compose file te vinden waarmee alle services gemakkelijk in één keer gedeployed kunnen worden. Kopieer dit bestand naar een machine waar docker op geïnstalleerd staat en run het commando `docker-compose up`, het kan ook zijn dat dit zonder streepje is (`docker compose up`). Om de stack te stoppen kun je het commando `docker-compose down` gebruiken. TIP: Het docker-compose.yml bestand kun je ook vinden in deze repository.
```
version: "3.4"
services:
  orchestrator:
    image: ghcr.io/days-stickworld/orchestrator:main
    ports: 
      - "5041:80"
    environment:
      - REDIS_HOST=redis # Verwijst in dit voorbeeld naar de redis container, maar kan ook een IP-adres zijn
      - PUBLIC_IP=127.0.0.1 # Aanpassen naar IP-adres waarop de orchestrator bereikbaar is.
      - DOCKER_NETWORK=days-stickworld # Optioneel, voegt de container toe aan een specifiek docker netwerk
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
  redis:
    image: redis
    
networks:
  default:
    name: days-stickworld
    driver: bridge
```
Je merkt misschien dat bovenstaand bestand geen gameserver bevat. Dit komt doordat de orchestrator zelf de eerste server voor je opstart. Zo heb je altijd een actieve server waarmee je kunt verbinden. Verder zal de orchestrator een nieuwe server opstarten wanneer de capaciteit op 70% of hoger komt.

### Losse componenten starten met docker
Naast het gebruik van een docker-compose bestand is het ook mogelijk om de diverse componenten los te starten met behulp van het `docker run` commando. Hieronder vind je de commando's om dit te doen. Let erop dat je de environment variables aanpast naar de juiste waardes.

**Redis:** `docker run -d -p 6379:6379 redis`  
**Orchestrator:** `docker run -d -v /var/run/docker.sock:/var/run/docker.sock -e REDIS_HOST=188.40.116.116 -e PUBLIC_IP=127.0.0.1 ghcr.io/days-stickworld/orchestrator:main`  
**Game server:** `docker run -d -p 7777:7777/udp -e REDIS_HOST=172.17.0.1 -e SERVER_CLUSTER=EU-1 -e SERVER_HOST=127.0.0.1 -e SERVER_ID=days-stickworld-01 -e SERVER_PORT=7777 ghcr.io/days-stickworld/game:latest`  

### Communicatie tussen de componenten
Wanneer dit allemaal draait dien je ervoor te zorgen dat de communicatie tussen de diverse componenten goed kan werken. Let hierbij op onderstaande punten. De communicatie tussen orchestrator, redis en game servers is in principe al geregeld wanneer je bovenstaande docker-compose file op één machine deployed.
- De orchestrator moet bij de redis instance kunnen komen
- De game server moet bij de redis instance kunnen komen
- De game client moet bij de orchestrator kunnen komen

### Orchestrator toevoegen in de game
Wanneer dit is opgezet kun je lokaal de game client opstarten. Het is hierbij wel belangrijk om in Unity de endpoint van de orchestrator aan te passen, zodat de game de beschikbare servers op kan vragen. Doorloop hiervoor de volgende stappen:
- Clone de [game](https://github.com/days-stickworld/game) repository
- Open het project in Unity
- Open de "Assets/Scenes/Menu" scene
- Klap "Main_Menu_New" uit
- Klap "Canv_Options" uit
- Klap "ServerPanel" uit
- Klik op "Scroll View" en open de inspector
- Scroll naar het component "Server Controller (Script)"
- Pas de waarde van "Orchestration Endpoint" aan

![](https://github.com/days-stickworld/deployment-manual/blob/main/Screenshot%202022-07-03%20185745.png?raw=true)


### Nieuwe build maken
Wanneer de orchestrator is aangepast kun je een nieuwe build van de game maken. Volg hiervoor de volgende stappen:
- Klik linksboven in Unity op "File"
- Klik op "Build Settings"
- Selecteer het platform "Windows, Mac, Linux"
- Selecteer je gewenste Target Platform
- Klik linksonderin op Build en selecteer een folder waar je deze build wil opslaan

De opgeslagen build kun je vervolgens starten, en als het goed is zie je de actieve game server die je eerder had opgestart.

### Vragen of problemen
Mocht je tijdens het gebruik van de game of orchestrator vragen hebben of problemen tegenkomen, kun je altijd een issue aanmaken in de desbetreffende repository.
