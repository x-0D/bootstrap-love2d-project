return {
  m_Name = "event_936",
  Id = 936,
  NameLocKey = "events/coastal_refugees",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 170,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 2,
      People = 0,
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
      People = 2,
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
    TargetCardID = "local_hunger_revolutions",
    Amount = 0
  },
  EventSolutions = {
    Production = 2,
    People = 4,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 500,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.01,
  ChanceStartSeason = 0,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}