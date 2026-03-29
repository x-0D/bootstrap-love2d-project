return {
  m_Name = "event_921",
  Id = 921,
  NameLocKey = "events/end_of_pollutant_regulation",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 100,
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
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "pollution_regulations",
    Amount = 0
  },
  EffectInsolvency = {
    Type = 5,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 100
  },
  EventSolutions = {
    Production = 0,
    People = 2,
    Science = 3
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 1500,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 30,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}