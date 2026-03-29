return {
  m_Name = "event_950",
  Id = 950,
  NameLocKey = "events/clima_apathy",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 150,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 2
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
      People = 2,
      Science = 0
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
      "carbon_capture",
      "research centers"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 2,
    People = 3,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 500,
  EmissionsMax = 2000,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}