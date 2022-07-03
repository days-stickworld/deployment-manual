# Handleiding Deployment
> Handleiding voor de deployment van het DAY's Stickworld Proof of Concept

Om een functionerende infrastructuur op te zetten voor DAY's Stickworld zijn er een viertal componenten nodig. De gehoste componenten kunnen gemakkelijk in docker gedraaid worden. Hieronder een overzicht van de componenten en een korte beschrijving hiervan:
- **Orchestrator:** De orchestrator monitort alle game servers en zorgt ervoor dat servers op- en afgeschaald kunnen worden.
- **Game server:** De game server zorgt ervoor dat clients kunnen verbinden en elkaar kunnen zien.
- **Redis:** Redis is nodig om de communicatie tussen orchestrator en server te kunnen faciliteren.
- **Game client:** De game client draait lokaal bij de gebruiker. Dit is het daadwerkelijke spel.

### Deployment van de infrastructuur
De docker containers van de gehoste componenten zijn te vinden in de bijbehorende repositories, onder "packages". Hieronder is een docker-compose file te vinden waarmee alle services gemakkelijk in één keer gedeployed kunnen worden. Kopieer dit bestand naar een machine waar docker op geïnstalleerd staat en run het commando `docker-compose up`, het kan ook zijn dat dit zonder streepje is (`docker compose up`). Om de stack te stoppen kun je het commando `docker-compose down` gebruiken.
```
INSERT DOCKER COMPOSE FILE
```

### Communicatie tussen de componenten
Wanneer dit allemaal draait dien je ervoor te zorgen dat de communicatie tussen de diverse componenten goed kan werken. Let hierbij op onderstaande punten. De communicatie tussen orchestrator, redis en game servers is in principe al geregeld wanneer je bovenstaande docker-compose file op één machine deployed.
- De orchestrator moet bij de redis instance kunnen komen
- De game server moet bij de redis instance kunnen komen
- De game client moet bij de orchestrator kunnen komen

### Orchestrator toevoegen in de game
Wanneer dit is opgezet kun je lokaal de game client opstarten. Het is hierbij wel belangrijk om in Unity de endpoint van de orchestrator aan te passen, zodat de game de beschikbare servers op kan vragen. Doorloop hiervoor de volgende stappen:
- Clone de ![game](https://github.com/days-stickworld/game) repository
- Open het project in Unity
- Open de "Menu" scene
- Klap "Main_Menu_New" uit
- Klap "Canv_Options" uit
- Klap "ServerPanel" uit
- Klik op "Scroll View" en open de inspector
- Scroll naar het component "Server Controller (Script)"
- Pas de waarde van "Orchestration Endpoint" aan

![](https://github.com/days-stickworld/deployment-manual/blob/main/Screenshot%202022-07-03%20185745.png?raw=true)
