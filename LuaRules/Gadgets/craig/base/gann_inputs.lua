-- Just simply a record of inputs to be handled for the GANN
local base_gann_inputs = {
    -- Team state
    "metal_curr",
    "metal_push",
    "metal_pull",
    "energy_curr",                                         -- energy = team ammo
    "energy_storage",                                      -- energy = team ammo
    "capturing_capacity",
    "los_capacity",
    "construction_capacity",
    -- Unit features
    "unit_defid",
    "chain_cost",
    "unit_cost",
    "unit_cap",
    "unit_view",
    "unit_speed",
    "unit_armour",
    "unit_firepower",
    "unit_penetration",
    "unit_range",
    "unit_storage",
    "unit_is_constructor",
    "unit_in_factories",
}

return base_gann_inputs
