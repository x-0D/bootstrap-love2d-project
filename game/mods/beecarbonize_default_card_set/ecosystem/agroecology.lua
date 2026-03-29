return {
  m_Name = "card_301",
  Id = 301,
  NameLocKey = "card_name/agroecology",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
    Science = 2
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -10,
  UpgradesTo = {
    "agroforestry",
    "regenerative_agriculture"
  },
  UpgradeTime = 100,
  Speed = 0.25,
  Emissions = 0,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "agricultural_calamity",
      Chance = -0.01
    },
    {
      EventId = "nitrogen_run_off",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_agroforestry_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "agroforestry",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_agroforestry_IL_BW.png"
}