return {
  m_Name = "event_1008",
  Id = 1008,
  NameLocKey = "events/antarctic_collaps",
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
    TargetCardID = "ecosystem_breakdown",
    Amount = 0
  },
  EventSolutions = {
    Production = 10,
    People = 0,
    Science = 7
  },
  EmissionThreshold = 2000,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = "EventIllustrations_EVENT_CARD_antarctic_collaps_HR.png",
  ScriptFile = "EventCardSO.cs",
  SpriteFile = "EventIllustrations_EVENT_CARD_antarctic_collaps_HR.png"
}