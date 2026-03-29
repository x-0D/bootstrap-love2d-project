return {
  m_Name = "event_1104",
  Id = 1104,
  NameLocKey = "events/food_conflicts",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 90,
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
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
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
    TargetCardID = "hunger_strikes",
    Amount = 0
  },
  EventSolutions = {
    Production = 7,
    People = 0,
    Science = 0
  },
  EmissionThreshold = 900,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = "EventIllustrations_EVENT_CARD_ food_conflicts_HR.png",
  ScriptFile = "EventCardSO.cs",
  SpriteFile = "EventIllustrations_EVENT_CARD_ food_conflicts_HR.png"
}