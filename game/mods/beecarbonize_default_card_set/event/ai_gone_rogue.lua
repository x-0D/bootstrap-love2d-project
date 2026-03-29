return {
  m_Name = "event_1031",
  Id = 1031,
  NameLocKey = "events/ai_gone_rogue",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 300,
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
    Type = 3,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = {
      "science_funding",
      "incubator",
      "research centers",
      "precision_agriculture",
      "hydropony",
      "geoengineering",
      "batteries",
      "meteo_models",
      "controlled_weather",
      "robobees",
      "space_research",
      "habitable_planet",
      "advanced_robotics",
      "massive_automation",
      "human_engineering",
      "space_mirrors"
    },
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "human_engineering",
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
    People = 6,
    Science = 12
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 80,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}