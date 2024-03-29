key_mgr_init() {
    if (isdefined(self.key_mgr)) {
        // ignore menu creation if already set
        return;
    }
    key_mgr = 
    {
        #key_config: spawnstruct(),
        #config: array(),
        #valid: array("action", "actionslotfour", "actionslotone", "actionslotthree", "actionslottwo", "ads", "attack", 
        "changeseat", "frag", "jump", "melee", "offhandspecial", "reload", "secondaryoffhand", "sprint", 
        "stance", "throw", "use", "vehicleattack", "vehiclemoveup", "weaponswitch")
    };

    self.key_mgr = key_mgr;

    // load the config
    key_config = key_mgr.key_config;
    key_config AtianMenuKeyConfig();

    self key_mgr_compile_key(#"open_menu", key_config.menu_open, array(#"ads", #"melee"));
    self key_mgr_compile_key(#"parent_page", key_config.parent_page, #"melee");
    self key_mgr_compile_key(#"last_item", key_config.last_item, #"ads");
    self key_mgr_compile_key(#"next_item", key_config.next_item, #"attack");
    self key_mgr_compile_key(#"select_item", key_config.select_item, #"use");
    self key_mgr_compile_key(#"fly_key", key_config.fly_key, #"sprint");
}

key_mgr_is_valid(key) {
    key_mgr_init();
    return array::contains(self.key_mgr.valid, key);
}

key_mgr_compile_key(id, config, default_config) {
    if (!isdefined(config)) {
        // no config, use default
        // force array
        if (!IsArray(default_config)) {
            default_config = array(default_config);
        }
        self.key_mgr.config[id] = default_config;
        return;
    }

    cfg_split = strtok(config, "+");

    cfg = array();

    for (i = 0; i < cfg_split.size; i++) {
        if (self key_mgr_is_valid(cfg_split[i])) {
            array::add(cfg, hash(cfg_split[i]));
        }
    }
    
    self.key_mgr.config[id] = cfg;
}

key_mgr_has_key_pressed(id, wait_release = false) {
    key_mgr_init();

    if (!isdefined(self.key_mgr.config[id])) {
        return; // bad config
    }
    
    key_cfg = self.key_mgr.config[id];

    for (i = 0; i < key_cfg.size; i++) {
        if (!self key_mgr_has_key_pressed_id(key_cfg[i])) {
            return false;
        }
    }
    if (!isdefined(wait_release) || !wait_release) {
        return true;
    }
    
    for (;;) {
        for (i = 0; i < key_cfg.size; i++) {
            if (!self key_mgr_has_key_pressed_id(key_cfg[i])) {
                return true;
            }
        }
        waitframe(1);
    }
}
key_mgr_has_key_pressed_id(id) {
    switch (id) {
        case #"action":
            return self actionbuttonpressed();
        case #"actionslotfour":
            return self actionslotfourbuttonpressed();
        case #"actionslotone":
            return self actionslotonebuttonpressed();
        case #"actionslotthree":
            return self actionslotthreebuttonpressed();
        case #"actionslottwo":
            return self actionslottwobuttonpressed();
        case #"ads":
            return self adsbuttonpressed();
        case #"attack":
            return self attackbuttonpressed();
        case #"changeseat":
            return self changeseatbuttonpressed();
        case #"frag":
            return self fragbuttonpressed();
        case #"jump":
            return self jumpbuttonpressed();
        case #"melee":
            return self meleebuttonpressed();
        case #"offhandspecial":
            return self offhandspecialbuttonpressed();
        case #"reload":
            return self reloadbuttonpressed();
        case #"secondaryoffhand":
            return self secondaryoffhandbuttonpressed();
        case #"sprint":
            return self sprintbuttonpressed();
        case #"stance":
            return self stancebuttonpressed();
        case #"throw":
            return self throwbuttonpressed();
        case #"use":
            return self usebuttonpressed();
        case #"vehicleattack":
            return self vehicleattackbuttonpressed();
        case #"vehiclemoveup":
            return self vehiclemoveupbuttonpressed();
        case #"weaponswitch":
            return self weaponswitchbuttonpressed();
        default:
            return false;
    }
}