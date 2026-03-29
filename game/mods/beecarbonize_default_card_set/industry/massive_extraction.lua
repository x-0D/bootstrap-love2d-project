return {
  m_Name = "card_117",
  Id = 117,
  NameLocKey = "card_name/massive_extraction",
  UpgradeCostBase = {
    Production = 1,
    People = 0,
    Science = 1
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "fracking",
    "deep_sea_mining",
    "desalination"
  },
  UpgradeTime = 40,
  Speed = 0.6,
  Emissions = 10,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 0,
  EventChancesOnCreated = {
    {
      EventId = "lack_of_fossil_fuels",
      Chance = -0.05
    },
    {
      EventId = "amazon_forest_collapse",
      Chance = 0.04
    },
    {
      EventId = "locl_conflicts",
      Chance = 0.04
    },
    {
      EventId = "biodiversity_breakdown",
      Chance = 0.04
    },
    {
      EventId = "food_chain_disruption",
      Chance = 0.04
    },
    {
      EventId = "mass_ekoterorism",
      Chance = 0.03
    },
    {
      EventId = "lack_nuclear_fuel",
      Chance = -0.02
    },
    {
      EventId = "oil_rig_explosion",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_no_limit_drilling_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "no_limit_drilling",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_no_limit_drilling_IL_BW.png"
}