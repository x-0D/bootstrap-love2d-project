return {
  m_Name = "event_963",
  Id = 963,
  NameLocKey = "events/no_greenland",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 110,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 5,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 50
  },
  EffectAfterDuration = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "massive_migration",
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
    Production = 0,
    People = 0,
    Science = 4
  },
  EmissionThreshold = 0,
  EmissionsMin = 900,
  EmissionsMax = 1500,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}