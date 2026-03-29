return {
  m_Name = "event_939",
  Id = 939,
  NameLocKey = "events/climate_refugees",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 120,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 3,
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
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "mass_airconditioning",
    Amount = 0
  },
  EffectInsolvency = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "resource_wars",
    Amount = 0
  },
  EventSolutions = {
    Production = 6,
    People = 0,
    Science = 3
  },
  EmissionThreshold = 0,
  EmissionsMin = 1000,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}