return {
  m_Name = "event_913",
  Id = 913,
  NameLocKey = "events/fake_enviro_labels",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 40,
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
    Type = 5,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 10
  },
  EffectAfterSolved = {
    Type = 1,
    TargetResource = {
      Production = 2,
      People = 0,
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
    Science = 2
  },
  EmissionThreshold = 0,
  EmissionsMin = 100,
  EmissionsMax = 700,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}