package com.watchtower.bridge;

import net.fabricmc.api.ClientModInitializer;
import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientLifecycleEvents;
import net.fabricmc.fabric.api.client.message.v1.ClientReceiveMessageEvents;

import net.minecraft.client.Minecraft;
import net.minecraft.client.gui.screens.ConnectScreen;
import net.minecraft.client.multiplayer.ServerData;
import net.minecraft.client.multiplayer.resolver.ServerAddress;
import net.minecraft.network.chat.Component;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class WatchtowerBridgeClient implements ClientModInitializer {

    private static final String SERVER_IP = "play.yourserver.net";
    private static final String BACKEND_URL = "https://your-backend.up.railway.app/chat";

    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    private static boolean switched = false;

    @Override
    public void onInitializeClient() {

        ClientLifecycleEvents.CLIENT_STARTED.register(client -> {
            connect();
        });

        ClientReceiveMessageEvents.CHAT.register((message, signed, sender, params, timestamp) -> {
            handleMessage(message.getString());
        });

        ClientReceiveMessageEvents.GAME.register((message, overlay) -> {
            handleMessage(message.getString());
        });
    }

    private void connect() {
    Minecraft mc = Minecraft.getInstance();

    mc.execute(() -> {
        ServerAddress address = ServerAddress.parseString(SERVER_IP);

        ServerData data = new ServerData(
                "Watchtower",
                SERVER_IP,
                ServerData.Type.OTHER
        );

        ConnectScreen.startConnecting(
                mc.screen,
                mc,
                address,
                data,
                false,
                null
        );
    });
}

    private void handleMessage(String text) {
        if (text == null || text.isBlank()) return;

        System.out.println("[CHAT] " + text);

        if (!switched && text.contains("Welcome to")) {
            switched = true;

            Minecraft mc = Minecraft.getInstance();
            mc.execute(() -> {
                if (mc.player != null) {
                    mc.player.connection.sendCommand("server Survival");
                }
            });
        }

        sendToBackend(text);
    }

    private void sendToBackend(String text) {
        try {
            String json = "{\"message\":\"" + text.replace("\"", "\\\"") + "\"}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(BACKEND_URL))
                    .timeout(Duration.ofSeconds(5))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();

            HTTP.sendAsync(request, HttpResponse.BodyHandlers.discarding());

        } catch (Exception ignored) {}
    }
}