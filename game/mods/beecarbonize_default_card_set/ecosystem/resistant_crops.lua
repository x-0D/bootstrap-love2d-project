return {
  m_Name = "card_412",
  Id = 412,
  NameLocKey = "card_name/resistant_crops",
  UpgradeCostBase = {
    Production = 3,
    People = 0,
    Science = 5
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 1,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 70,
  Speed = 0.25,
  Emissions = 0,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "no_more_coffee",
      Chance = -0.02
    },
    {
      EventId = "local_hunger_revolutions",
      Chance = -0.01
    },
    {
      EventId = "tragic_harvest",
      Chance = -0.01
    },
    {
      EventId = "food_chain_disruption",
      Chance = -0.01
    },
    {
      EventId = "agricultural_calamity",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_resistant_crops_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "resistant_crops",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_resistant_crops_IL_BW.png"
}