#include <cstrike>
#include <sourcemod>
#include "get5.inc" // Load get5.inc from the sourcemod includes folder (It contains Get5_OnEvent which we are using here)
#include <system2> // https://github.com/dordnung/System2
#include <json>  // https://github.com/clugg/sm-json

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0.1"

ConVar g_ApiUrlCvar;

public Plugin myinfo = {
	name = "Get5 Event API",
	author = "Demetrius",
	description = "Sends get5 events as JSON HTTP POST requests.",
	version = PLUGIN_VERSION,
	url = "https://github.com/stalsus/get5_eventapi"
};

public void OnPluginStart() {
	g_ApiUrlCvar = CreateConVar("get5_eventapi_url", "", "URL the get5 api is hosted at");
	RegConsoleCmd("get5_eventapi_status", Command_Status);
}

public Action Command_Status(int client, int args) {
	bool system2Available = LibraryExists("system2");
	char url[1024];
	GetConVarString(g_ApiUrlCvar, url, sizeof(url));

	JSON_Object json = new JSON_Object();
	json.SetInt("get5_gamestate", view_as<int>(Get5_GetGameState()));
	json.SetBool("system2_available", system2Available);
	json.SetString("plugin_version", PLUGIN_VERSION);
	json.SetString("api_url", url);

	char buffer[2048];
	json.Encode(buffer, sizeof(buffer), true);
	json_cleanup_and_delete(json);

	ReplyToCommand(client, buffer);

	return Plugin_Handled;
}

public void Get5_OnEvent(const char[] eventJson) {
	char url[1024]; // Get our url
	GetConVarString(g_ApiUrlCvar, url, sizeof(url));

	System2HTTPRequest httpRequest = new System2HTTPRequest(HttpResponseCallback, url);
	httpRequest.SetHeader("Content-Type", "application/json");
	httpRequest.SetData(eventJson);
	httpRequest.POST();
	delete httpRequest;
}

public void HttpResponseCallback(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method) {
	if (!success) {
		LogMessage("Failed to send request");
		LogMessage(error);
	}
}