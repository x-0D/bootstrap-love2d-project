return {
  m_Name = "event_930",
  Id = 930,
  NameLocKey = "events/widespread_cancer",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 330,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 3,
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
      People = 1,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectInsolvency = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "uninhabitable_30pct",
    Amount = 0
  },
  EventSolutions = {
    Production = 4,
    People = 0,
    Science = 2
  },
  EmissionThreshold = 0,
  EmissionsMin = 600,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}