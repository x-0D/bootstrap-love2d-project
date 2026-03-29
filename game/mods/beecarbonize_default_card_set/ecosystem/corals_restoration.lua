return {
  m_Name = "card_319",
  Id = 319,
  NameLocKey = "card_name/corals_restoration",
  UpgradeCostBase = {
    Production = 5,
    People = 0,
    Science = 5
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 1
  },
  UpgradeBonusEmissions = -100,
  UpgradesTo = nil,
  UpgradeTime = 150,
  Speed = 0.1,
  Emissions = -3,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "biodiversity_breakdown",
      Chance = -0.01
    },
    {
      EventId = "food_shortage_at_equator",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_corals_restoration_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "corals_restoration",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_corals_restoration_IL_BW.png"
}