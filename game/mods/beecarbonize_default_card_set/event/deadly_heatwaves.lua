return {
  m_Name = "event_938",
  Id = 938,
  NameLocKey = "events/deadly_heatwaves",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 180,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 2,
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
    TargetCardID = "climate_refugees",
    Amount = 0
  },
  EventSolutions = {
    Production = 3,
    People = 0,
    Science = 3
  },
  EmissionThreshold = 0,
  EmissionsMin = 750,
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