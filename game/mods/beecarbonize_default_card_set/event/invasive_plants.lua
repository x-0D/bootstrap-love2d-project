return {
  m_Name = "event_1033",
  Id = 1033,
  NameLocKey = "events/invasive_plants",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 330,
  Repetition = 1,
  EffectsEveryRound = {
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterDuration = {
    Type = 3,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = {
      "agroecology",
      "agroforestry",
      "carbon_storing_pasture",
      "mangroves_planting",
      "ecosystem_engineers",
      "ecosystem_restoration",
      "protected_landscapes",
      "30by30",
      "regenerative_agriculture"
    },
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "ecocentrism",
    Amount = 0
  },
  EffectInsolvency = {
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EventSolutions = {
    Production = 7,
    People = 0,
    Science = 9
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.01,
  ChanceStartSeason = 70,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}