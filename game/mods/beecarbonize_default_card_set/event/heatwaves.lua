return {
  m_Name = "event_915",
  Id = 915,
  NameLocKey = "events/heatwaves",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 130,
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
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 3,
      Science = 3
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 1,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 2
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
    Production = 4,
    People = 0,
    Science = 0
  },
  EmissionThreshold = 250,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 1,
  Sprite = "EventIllustrations_EVENT_CARD_ heatwaves_HR.png",
  ScriptFile = "EventCardSO.cs",
  SpriteFile = "EventIllustrations_EVENT_CARD_ heatwaves_HR.png"
}