return {
  m_Name = "card_129",
  Id = 129,
  NameLocKey = "card_name/deep_sea_mining",
  UpgradeCostBase = {
    Production = 0,
    People = 3,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 2,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 40,
  Speed = 0.6,
  Emissions = 6,
  SectorType = 1,
  Categories = 524288,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 0,
  EventChancesOnCreated = {
    {
      EventId = "biodiversity_breakdown",
      Chance = 0.05
    },
    {
      EventId = "deep_see_fishing",
      Chance = 0.05
    },
    {
      EventId = "mass_ekoterorism",
      Chance = 0.02
    },
    {
      EventId = "lack_rare_metals",
      Chance = -0.05
    },
    {
      EventId = "oil_rig_explosion",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_deep_sea_mining.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "deep_sea_mining",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_deep_sea_mining.png"
}