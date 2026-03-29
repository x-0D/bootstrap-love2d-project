return {
  m_Name = "card_110",
  Id = 110,
  NameLocKey = "card_name/fracking",
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
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 35,
  Speed = 0.8,
  Emissions = 11,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "gas_shortage",
      Chance = -0.03
    },
    {
      EventId = "mass_ekoterorism",
      Chance = 0.02
    },
    {
      EventId = "ekoterorism",
      Chance = 0.02
    },
    {
      EventId = "end_of_pollutant_regulation",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_fracking_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "fracking",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_fracking_IL_BW.png"
}