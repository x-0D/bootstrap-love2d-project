return {
  m_Name = "event_959",
  Id = 959,
  NameLocKey = "events/food_chain_disruption",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 200,
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
    TargetCardID = "world_hunger",
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 1,
    TargetResource = {
      Production = 0,
      People = 3,
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
    Production = 6,
    People = 6,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 1500,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}