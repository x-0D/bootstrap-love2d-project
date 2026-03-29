return {
  m_Name = "card_230",
  Id = 230,
  NameLocKey = "card_name/carbon_tax_2.0",
  UpgradeCostBase = {
    Production = 0,
    People = 6,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 3,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = "carbon_tax_3.0",
  UpgradeTime = 70,
  Speed = 0.25,
  Emissions = -4,
  SectorType = 2,
  Categories = nil,
  ReplacedByUpgrade = 1,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "lack_rare_metals",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_carbon_tax_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "carbon_tax",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_carbon_tax_IL_BW.png"
}