return {
  m_Name = "event_1105",
  Id = 1105,
  NameLocKey = "events/boreal_forest_collapse",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 60,
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
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "ecosystem_restoration",
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
    Amount = 300
  },
  EventSolutions = {
    Production = 0,
    People = 7,
    Science = 0
  },
  EmissionThreshold = 1400,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = "EventIllustrations_EVENT_CARD_boreal_forest_collapse_HR.png",
  ScriptFile = "EventCardSO.cs",
  SpriteFile = "EventIllustrations_EVENT_CARD_boreal_forest_collapse_HR.png"
}