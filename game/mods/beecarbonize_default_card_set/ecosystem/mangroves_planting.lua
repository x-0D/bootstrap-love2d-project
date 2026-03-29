return {
  m_Name = "card_318",
  Id = 318,
  NameLocKey = "card_name/mangroves_planting",
  UpgradeCostBase = {
    Production = 2,
    People = 2,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 90,
  Speed = 0.25,
  Emissions = -1,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "massive_floods",
      Chance = -1
    },
    {
      EventId = "rising_ocean_levels",
      Chance = -0.01
    },
    {
      EventId = "sinking_of_coastal_countries",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_mangroves_planting_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "mangroves_planting",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_mangroves_planting_IL_BW.png"
}