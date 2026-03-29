return {
  m_Name = "event_935",
  Id = 935,
  NameLocKey = "events/sinking_of_coastal_countries",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 170,
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
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "coastal_refugees",
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "coastal_bariers",
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
    Production = 3,
    People = 0,
    Science = 4
  },
  EmissionThreshold = 0,
  EmissionsMin = 500,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.01,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}