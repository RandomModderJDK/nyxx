part of nyxx;

/// Emitted when client connects/disconnecs/mutes etc to voice channel
class VoiceStateUpdateEvent {
  /// Voices state
  VoiceState state;

  Map<String, dynamic> json;

  VoiceStateUpdateEvent._new(Client client, this.json) {
    state = new VoiceState._new(client, json['d'] as Map<String, dynamic>);

    client._events.onVoiceStateUpdate.add(this);
  }
}
