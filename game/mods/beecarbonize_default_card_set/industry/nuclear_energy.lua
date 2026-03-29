return {
  m_Name = "card_107",
  Id = 107,
  NameLocKey = "card_name/nuclear_energy",
  UpgradeCostBase = {
    Production = 6,
    People = 0,
    Science = 4
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "nuclear2_0",
    "safer_nuclear",
    "fusion_power"
  },
  UpgradeTime = 220,
  Speed = 0.4,
  Emissions = 1,
  SectorType = 1,
  Categories = "0D000000",
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "nuclear_catastrophe",
      Chance = 0.01
    },
    {
      EventId = "lack_nuclear_fuel",
      Chance = 0.01
    },
    {
      EventId = "nuclear_spill",
      Chance = 0.01
    },
    {
      EventId = "energy_shortage",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = "nuclear_cleanup",
  Sprite = "science_atlas_karta_SC_nuclear_energy_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "nuclear_energy",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_nuclear_energy_IL_BW.png"
}