return {
  m_Name = "card_463",
  Id = 463,
  NameLocKey = "card_name/space_mirrors",
  UpgradeCostBase = {
    Production = 15,
    People = 10,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 250,
  UpgradesTo = "planetary_thermostat",
  UpgradeTime = 290,
  Speed = 0.6,
  Emissions = -5,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 1,
  UpgradeRandom = 0,
  Rarity = 4,
  EventChancesOnCreated = {
    {
      EventId = "kessler_syndrom",
      Chance = 0.03
    },
    {
      EventId = "regional_clima",
      Chance = 0.02
    },
    {
      EventId = "asteroid_swarm",
      Chance = 0.02
    },
    {
      EventId = "local_protests",
      Chance = 0.01
    },
    {
      EventId = "lack_rare_metals",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_SC_space_mirrors_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "space_mirrors",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_SC_space_mirrors_IL_BW.png"
}