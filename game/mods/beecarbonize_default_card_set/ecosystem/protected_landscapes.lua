return {
  m_Name = "card_323",
  Id = 323,
  NameLocKey = "card_name/protected_landscapes",
  UpgradeCostBase = {
    Production = 4,
    People = 3,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -40,
  UpgradesTo = {
    "30by30",
    "biodiversity_credits"
  },
  UpgradeTime = 120,
  Speed = 0.1,
  Emissions = -2,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "intense_drought",
      Chance = -0.01
    },
    {
      EventId = "forest_fires",
      Chance = -0.01
    },
    {
      EventId = "deep_see_fishing",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_protected_landscapes_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "protected_landscapes",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_protected_landscapes_IL_BW.png"
}