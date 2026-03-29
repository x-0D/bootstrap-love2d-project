return {
  m_Name = "event_908",
  Id = 908,
  NameLocKey = "events/crop_failure",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 140,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 1,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterDuration = {
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 1,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 1
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectInsolvency = {
    Type = 3,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = {
      "agroecology",
      "amazon_reforestation",
      "ecosystem_restoration"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 3,
    People = 0,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 400,
  EmissionsMax = 900,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}