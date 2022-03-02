# Get5 Event API

This sourcemod plugin sends [Get5 Events](https://github.com/splewis/get5/wiki/Event-logs) as json http post requests to a webserver set with the CVAR `get5_eventapi_url`.

### CVARs
```
get5_eventapi_url - Set's the server url to send the post request to
get5_eventapi_status - Prints info about the plugin
```

### Server Requirements
    
To use this plugin on your server, you must have the following:

- [Get5](https://github.com/splewis/get5)
- [System2](https://github.com/dordnung/System2)

### Build Requirements

To build the plugin, you must have the following:

- [Get5](https://github.com/splewis/get5)
- [System2](https://github.com/dordnung/System2)
- [sm-json](https://github.com/clugg/sm-json)
