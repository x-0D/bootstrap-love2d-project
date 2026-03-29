return {
  m_Name = "card_332",
  Id = 332,
  NameLocKey = "card_name/regenerative_agriculture",
  UpgradeCostBase = {
    Production = 0,
    People = 4,
    Science = 3
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 1
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "aquaponics",
    "carbon_agriculture",
    "kelp_plantation"
  },
  UpgradeTime = 100,
  Speed = 0.25,
  Emissions = -1,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "nitrogen_run_off",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_regenerative_agriculture_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "regenerative_agriculture",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_regenerative_agriculture_IL_BW.png"
}