return {
  m_Name = "card_109",
  Id = 109,
  NameLocKey = "card_name/safer_nuclear",
  UpgradeCostBase = {
    Production = 0,
    People = 1,
    Science = 4
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 2,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 150,
  Speed = 0,
  Emissions = 0,
  SectorType = 1,
  Categories = "0D000000",
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "nuclear_catastrophe",
      Chance = -0.06
    },
    {
      EventId = "nuclear_spill",
      Chance = -0.03
    }
  },
  OnDestroyedEvents = "nuclear_cleanup",
  Sprite = "science_atlas_karta_SC_safer_nuclear_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "safer_nuclear",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_safer_nuclear_IL_BW.png"
}