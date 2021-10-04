#include <cstrike>
#include <sourcemod>
#include "include/get5.inc"
#include <system2> // https://github.com/dordnung/System2
#include <json>  // https://github.com/clugg/sm-json

#pragma semicolon 1
#pragma newdecls required

ConVar g_ApiUrlCvar;

public Plugin myinfo = {
	name = "Get5 Event API",
	author = "Demetrius",
	description = "Sends get5 events as JSON HTTP POST requests.",
	version = "0.0.1",
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
	json.SetString("plugin_version", "0.0.1");
	json.SetString("api_url", url);

	char buffer[512];
	json.Encode(buffer, sizeof(buffer), true);

	ReplyToCommand(client, buffer);

	delete json;
	return Plugin_Handled;
}

public void Get5_OnEvent(const char[] eventJson) {
	// Get our url
	char url[1024];
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
	}
}