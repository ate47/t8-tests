
MainRunner() {
    self endon(#"disconnect", #"spawned_player");
    level endon(#"end_game", #"game_ended");

    for(;;)
    {
        if (is_mod_activated("maxpoints")) {
            self.score = 99999;
        }

        if (isdefined(self.tool_invulnerability) && self.tool_invulnerability) {
            self freezeControls(false);
            self enableInvulnerability();
            self val::set(#"atianmod", "disable_oob", true);
        }
        if (isdefined(self.tool_zmignoreme) && self.tool_zmignoreme) {
            self val::set(#"atianmod", "ignoreme", true);
        }

        if (isdefined(self.rocketman_rocket) && self key_mgr_has_key_pressed(#"fly_key", false)) {
            // delete the rocketman rocket if the user is sprinting
            self.rocketman_rocket delete();
        }

        // waits a single frame
        waitframe(1);
    }
}
