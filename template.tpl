___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "US Privacy Signals",
  "categories": [
    "UTILITY"
  ],
  "description": "Combines US opt-out signals (GPC, IAB GPP and US Privacy strings, CMP cookies, Google Consent Mode) and the visitor region into one decision, plus Meta, Google Ads and TikTok limited data use flags.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "returnType",
    "displayName": "Return Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "decision",
        "displayValue": "Decision (allow, or the opt-out action below)"
      },
      {
        "value": "restricted",
        "displayValue": "Restricted (true / false)"
      },
      {
        "value": "object",
        "displayValue": "Full object (decision, reason, signals, geo, vendor flags)"
      },
      {
        "value": "metaDpo",
        "displayValue": "Meta - data_processing_options"
      },
      {
        "value": "metaDpoCountry",
        "displayValue": "Meta - data_processing_options_country"
      },
      {
        "value": "metaDpoState",
        "displayValue": "Meta - data_processing_options_state"
      },
      {
        "value": "googleAdsRdp",
        "displayValue": "Google Ads - restricted data processing"
      },
      {
        "value": "tiktokLdu",
        "displayValue": "TikTok - limited_data_use"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "decision",
    "alwaysInSummary": true,
    "help": "The value this variable returns. All return types are computed from the same settings, so create one variable per value you need (for example one for the decision and one for each vendor flag) with identical settings.\u003cul\u003e\u003cli\u003e\u003cb\u003eDecision\u003c/b\u003e: \u003ci\u003eallow\u003c/i\u003e when the visitor is not restricted. Otherwise the value set in \u003cb\u003eDecision value when the visitor opted out\u003c/b\u003e (\u003ci\u003elimited\u003c/i\u003e or \u003ci\u003eblock\u003c/i\u003e). A variable returns only one of the two. Use it in trigger conditions.\u003c/li\u003e\u003cli\u003e\u003cb\u003eRestricted\u003c/b\u003e: \u003ci\u003etrue\u003c/i\u003e when the decision is \u003ci\u003elimited\u003c/i\u003e or \u003ci\u003eblock\u003c/i\u003e, otherwise \u003ci\u003efalse\u003c/i\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eFull object\u003c/b\u003e: the decision plus the reason, the status of each signal, the visitor location and all vendor flags. Use it in Preview to see why a decision was made.\u003c/li\u003e\u003cli\u003e\u003cb\u003eMeta - data_processing_options\u003c/b\u003e: \u003ci\u003e[\u0027LDU\u0027]\u003c/i\u003e when restricted, otherwise \u003ci\u003e[]\u003c/i\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eMeta - data_processing_options_country / _state\u003c/b\u003e: numbers when restricted (see the Meta Limited Data Use section), otherwise \u003ci\u003eundefined\u003c/i\u003e.\u003c/li\u003e\u003cli\u003e\u003cb\u003eGoogle Ads - restricted data processing\u003c/b\u003e and \u003cb\u003eTikTok - limited_data_use\u003c/b\u003e: \u003ci\u003etrue\u003c/i\u003e when restricted, otherwise \u003ci\u003efalse\u003c/i\u003e.\u003c/li\u003e\u003c/ul\u003eSee \u003ca href\u003d\"https://github.com/stape-io/us-privacy-signals-variable/blob/main/README.md#return-types\"\u003eReturn types\u003c/a\u003e in the documentation for the values and how to map them into tags."
  },
  {
    "type": "GROUP",
    "name": "decisionGroup",
    "displayName": "Decision",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "RADIO",
        "name": "optOutAction",
        "displayName": "Decision value when the visitor opted out",
        "radioItems": [
          {
            "value": "limited",
            "displayValue": "limited (send with limited data use flags)"
          },
          {
            "value": "block",
            "displayValue": "block (do not send)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "limited",
        "help": "The value the \u003cb\u003eDecision\u003c/b\u003e returns for visitors who opted out and are inside the region rules. Everyone else gets \u003ci\u003eallow\u003c/i\u003e. The variable does not stop or change tags by itself: your tags and triggers act on its output.\u003cul\u003e\u003cli\u003e\u003cb\u003elimited\u003c/b\u003e: the events are still sent, processed under each vendor\u0027s restricted mode. Map the vendor flag return types (Meta data_processing_options \u003ci\u003e[\u0027LDU\u0027]\u003c/i\u003e, Google Ads restricted data processing \u003ci\u003etrue\u003c/i\u003e, TikTok limited_data_use \u003ci\u003etrue\u003c/i\u003e) into your tags.\u003c/li\u003e\u003cli\u003e\u003cb\u003eblock\u003c/b\u003e: the events are not sent. Use the Decision in an exception trigger (for example \u003ci\u003eDecision equals block\u003c/i\u003e) on the tags that must not fire.\u003c/li\u003e\u003c/ul\u003eOnly the Decision changes with this setting. The Restricted and vendor flag return types are the same for both values, so this field is shown only for the Decision and Full object return types.",
        "enablingConditions": [
          {
            "paramName": "returnType",
            "paramValue": "decision",
            "type": "EQUALS"
          },
          {
            "paramName": "returnType",
            "paramValue": "object",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SELECT",
        "name": "resolutionMode",
        "displayName": "When signals disagree",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "anyOptOut",
            "displayValue": "Any opt-out wins"
          },
          {
            "value": "priority",
            "displayValue": "First signal with a clear answer wins"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "anyOptOut",
        "help": "\u003cb\u003eAny opt-out wins\u003c/b\u003e: if any enabled signal reports an opt-out, the visitor is treated as opted out. The signal priority order only decides which signal is reported as the reason, so in this mode the table is shown only for the \u003cb\u003eFull object\u003c/b\u003e return type.\u003cbr/\u003e\u003cbr/\u003e\u003cb\u003eFirst signal with a clear answer wins\u003c/b\u003e: signals are checked in the priority order below. The first one that reports either an opt-out or an explicit \"did not opt out\" decides. For example, an explicit CMP choice placed above GPC overrides GPC. GPC can only report an opt-out, never \"did not opt out\"."
      },
      {
        "type": "RADIO",
        "name": "noSignalBehavior",
        "displayName": "When no signal gives a clear answer",
        "radioItems": [
          {
            "value": "allow",
            "displayValue": "Treat as not opted out (allow)"
          },
          {
            "value": "optOut",
            "displayValue": "Treat as opted out (fail closed)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "allow",
        "help": "Applies when no enabled signal reports either an opt-out or an explicit \"did not opt out\", for example when the GPP string is missing or its format is not recognized. With \u003cb\u003efail closed\u003c/b\u003e, those visitors get the opt-out action and the reason \u003ci\u003eno_clear_signal\u003c/i\u003e.\u003cbr/\u003e\u003cbr/\u003eGPC can only report an opt-out, never \"did not opt out\". With only GPC enabled, every visitor without GPC is treated as opted out. Google Consent Mode only reports \"did not opt out\" when \u003cb\u003eWhat Google Consent Mode can report\u003c/b\u003e is set to \u003cb\u003eOpt-out and did not opt out\u003c/b\u003e. The region rules still apply first."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "signalPriority",
        "displayName": "Signal priority (top \u003d highest)",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Signal",
            "name": "signal",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "gpc",
                "displayValue": "Global Privacy Control (Sec-GPC header)"
              },
              {
                "value": "gpp",
                "displayValue": "IAB GPP string"
              },
              {
                "value": "us_privacy",
                "displayValue": "IAB US Privacy string"
              },
              {
                "value": "cmp",
                "displayValue": "CMP cookie"
              },
              {
                "value": "consent_mode",
                "displayValue": "Google Consent Mode"
              }
            ],
            "isUnique": true
          }
        ],
        "newRowButtonText": "Add signal",
        "help": "The order in which signals are checked. Each signal can be listed once. Signals missing from this table, or all of them when the table is empty, are checked after the listed ones in the default order: GPC, GPP, US Privacy, CMP, Google Consent Mode.",
        "enablingConditions": [
          {
            "paramName": "resolutionMode",
            "paramValue": "priority",
            "type": "EQUALS"
          },
          {
            "paramName": "returnType",
            "paramValue": "object",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "signalsGroup",
    "displayName": "Signals",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableGpc",
        "checkboxText": "Global Privacy Control (Sec-GPC request header)",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Browsers with GPC turned on send \u003ci\u003eSec-GPC: 1\u003c/i\u003e with every request. A value of \u003ci\u003e1\u003c/i\u003e is an opt-out. If your server container sits behind a CDN or proxy, make sure it forwards this header.\u003cbr/\u003e\u003cbr/\u003eWhen the header is missing, the GPC flag in the GA4 \u003ci\u003ex-ga-gcd\u003c/i\u003e value is used as a fallback. The Google tag only sets that flag in the regions where it honors GPC, so the header remains the main source."
      },
      {
        "type": "CHECKBOX",
        "name": "enableGpp",
        "checkboxText": "IAB Global Privacy Platform (GPP) string",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "The Google tag forwards the GPP string from the CMP\u0027s \u003ci\u003e__gpp\u003c/i\u003e API automatically. It is read from the \u003ci\u003ex-sst-system_properties.gpp\u003c/i\u003e and \u003ci\u003ex-sst-system_properties.gpp_sid\u003c/i\u003e Event Data keys (then \u003ci\u003ex-ads-gpp\u003c/i\u003e / \u003ci\u003ex-ads-gpp_sid\u003c/i\u003e, then the \u003ci\u003eOTGPPConsent\u003c/i\u003e cookie that OneTrust writes when GPP is configured).\u003cbr/\u003e\u003cbr/\u003eDecoded sections: US National (7, versions 1 and 2), the state sections 8 to 27 (California, Virginia, Colorado, Utah, Connecticut, Florida, Montana, Oregon, Texas, Delaware, Iowa, Nebraska, New Hampshire, New Jersey, Tennessee, Minnesota, Maryland, Indiana, Kentucky and Rhode Island) and the legacy US Privacy section (6). A section is an opt-out when its Sale, Sharing or Targeted Advertising opt-out field is \u003ci\u003eOpted Out\u003c/i\u003e, or when its GPC sub-section is set. Other sections, and US National version 3, are reported as unknown.",
        "subParams": [
          {
            "type": "GROUP",
            "name": "gppGroup",
            "displayName": "",
            "groupStyle": "NO_ZIPPY",
            "subParams": [
              {
                "type": "TEXT",
                "name": "gppString",
                "displayName": "GPP string (optional override)",
                "simpleValueType": true,
                "help": "Leave empty to read it from Event Data. Use this when the GPP string arrives under another key, for example from the Data Client."
              },
              {
                "type": "TEXT",
                "name": "gppSid",
                "displayName": "GPP applicable section IDs (optional override)",
                "simpleValueType": true,
                "help": "Comma or underscore separated section IDs, for example \u003ci\u003e7\u003c/i\u003e or \u003ci\u003e7_8\u003c/i\u003e. When present, only these sections are evaluated. Leave empty to read it from Event Data."
              }
            ],
            "enablingConditions": [
              {
                "paramName": "enableGpp",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableUsPrivacy",
        "checkboxText": "IAB US Privacy string (us_privacy)",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "The 4-character CCPA string, for example \u003ci\u003e1YYN\u003c/i\u003e. The third character is the opt-out: \u003ci\u003eY\u003c/i\u003e \u003d opted out, \u003ci\u003eN\u003c/i\u003e \u003d not opted out. It is read from \u003ci\u003ex-sst-system_properties.us_privacy\u003c/i\u003e, \u003ci\u003ex-ads-us_privacy\u003c/i\u003e, then the \u003ci\u003eusprivacy\u003c/i\u003e and \u003ci\u003eus_privacy\u003c/i\u003e cookies.",
        "subParams": [
          {
            "type": "GROUP",
            "name": "usPrivacyGroup",
            "displayName": "",
            "groupStyle": "NO_ZIPPY",
            "subParams": [
              {
                "type": "TEXT",
                "name": "usPrivacyString",
                "displayName": "US Privacy string (optional override)",
                "simpleValueType": true
              }
            ],
            "enablingConditions": [
              {
                "paramName": "enableUsPrivacy",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableCmp",
        "checkboxText": "CMP cookie",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Reads the consent cookie of your CMP. The cookie is only available when the server container runs on a subdomain of your website (same-site cookies).",
        "subParams": [
          {
            "type": "GROUP",
            "name": "cmpGroup",
            "displayName": "",
            "groupStyle": "NO_ZIPPY",
            "subParams": [
              {
                "type": "SELECT",
                "name": "cmpPreset",
                "displayName": "CMP",
                "macrosInSelect": false,
                "selectItems": [
                  {
                    "value": "onetrust",
                    "displayValue": "OneTrust (OptanonConsent)"
                  },
                  {
                    "value": "cookiebot",
                    "displayValue": "Cookiebot (CookieConsent)"
                  },
                  {
                    "value": "trustarc",
                    "displayValue": "TrustArc (notice_gdpr_prefs / notice_preferences)"
                  },
                  {
                    "value": "custom",
                    "displayValue": "Custom cookie"
                  }
                ],
                "simpleValueType": true,
                "defaultValue": "onetrust",
                "help": "Usercentrics keeps consent in the browser\u0027s local storage, which the server cannot read. For Usercentrics, use its GPP output or write a custom cookie and pick \u003cb\u003eCustom cookie\u003c/b\u003e."
              },
              {
                "type": "GROUP",
                "name": "oneTrustGroup",
                "displayName": "",
                "groupStyle": "NO_ZIPPY",
                "subParams": [
                  {
                    "type": "TEXT",
                    "name": "oneTrustCategory",
                    "displayName": "OneTrust targeting category ID",
                    "simpleValueType": true,
                    "defaultValue": "C0004",
                    "help": "The category that covers sale, sharing and targeted advertising. \u003ci\u003eC0004:0\u003c/i\u003e in the \u003ci\u003egroups\u003c/i\u003e value is an opt-out, \u003ci\u003eC0004:1\u003c/i\u003e is not. \u003ci\u003ebrowserGpcFlag\u003d1\u003c/i\u003e in the cookie (the browser had GPC turned on) is also an opt-out."
                  }
                ],
                "enablingConditions": [
                  {
                    "paramName": "cmpPreset",
                    "paramValue": "onetrust",
                    "type": "EQUALS"
                  }
                ]
              },
              {
                "type": "GROUP",
                "name": "trustArcGroup",
                "displayName": "",
                "groupStyle": "NO_ZIPPY",
                "subParams": [
                  {
                    "type": "TEXT",
                    "name": "trustArcCategory",
                    "displayName": "TrustArc advertising category index",
                    "simpleValueType": true,
                    "defaultValue": "2",
                    "valueValidators": [
                      {
                        "type": "NON_NEGATIVE_NUMBER"
                      }
                    ],
                    "help": "\u003ci\u003e0\u003c/i\u003e \u003d required, \u003ci\u003e1\u003c/i\u003e \u003d functional, \u003ci\u003e2\u003c/i\u003e \u003d advertising. The visitor opted out when this index is missing from \u003ci\u003enotice_gdpr_prefs\u003c/i\u003e, or when the \u003ci\u003enotice_preferences\u003c/i\u003e level is lower than it."
                  }
                ],
                "enablingConditions": [
                  {
                    "paramName": "cmpPreset",
                    "paramValue": "trustarc",
                    "type": "EQUALS"
                  }
                ]
              },
              {
                "type": "GROUP",
                "name": "customCookieGroup",
                "displayName": "",
                "groupStyle": "NO_ZIPPY",
                "subParams": [
                  {
                    "type": "TEXT",
                    "name": "cmpCustomCookieName",
                    "displayName": "Cookie name",
                    "simpleValueType": true,
                    "valueValidators": [
                      {
                        "type": "NON_EMPTY"
                      }
                    ]
                  },
                  {
                    "type": "SELECT",
                    "name": "cmpCustomMatchType",
                    "displayName": "Match type",
                    "macrosInSelect": false,
                    "selectItems": [
                      {
                        "value": "equals",
                        "displayValue": "Equals"
                      },
                      {
                        "value": "contains",
                        "displayValue": "Contains"
                      },
                      {
                        "value": "regex",
                        "displayValue": "Matches RegEx (ignore case)"
                      }
                    ],
                    "simpleValueType": true,
                    "defaultValue": "equals"
                  },
                  {
                    "type": "TEXT",
                    "name": "cmpCustomOptOutValue",
                    "displayName": "Value that means opted out",
                    "simpleValueType": true,
                    "valueValidators": [
                      {
                        "type": "NON_EMPTY"
                      }
                    ]
                  },
                  {
                    "type": "TEXT",
                    "name": "cmpCustomOptInValue",
                    "displayName": "Value that means not opted out (optional)",
                    "simpleValueType": true,
                    "help": "A cookie that matches this value reports an explicit \"did not opt out\". Without it, a cookie that does not match the opt-out value is reported as unknown. It matters in two cases: in the \u003cb\u003eFirst signal with a clear answer wins\u003c/b\u003e mode, where it can decide the result, and with \u003cb\u003eTreat as opted out (fail closed)\u003c/b\u003e, where it keeps visitors who did not opt out from being treated as opted out."
                  }
                ],
                "enablingConditions": [
                  {
                    "paramName": "cmpPreset",
                    "paramValue": "custom",
                    "type": "EQUALS"
                  }
                ]
              }
            ],
            "enablingConditions": [
              {
                "paramName": "enableCmp",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableConsentMode",
        "checkboxText": "Google Consent Mode",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Reads the Data Tag \u003ci\u003econsent_state\u003c/i\u003e, then the GA4 \u003ci\u003ex-ga-gcd\u003c/i\u003e value, then the GA4 \u003ci\u003ex-ga-gcs\u003c/i\u003e value, and uses the first one that gives an answer. \u003ci\u003ead_storage\u003c/i\u003e, \u003ci\u003ead_user_data\u003c/i\u003e or \u003ci\u003ead_personalization\u003c/i\u003e denied is an opt-out. \u003ci\u003ead_storage\u003c/i\u003e granted is reported as set in \u003cb\u003eWhat Google Consent Mode can report\u003c/b\u003e. \u003ci\u003ex-ga-gcs\u003c/i\u003e only carries \u003ci\u003ead_storage\u003c/i\u003e, so it is used when \u003ci\u003ex-ga-gcd\u003c/i\u003e is missing.",
        "subParams": [
          {
            "type": "GROUP",
            "name": "consentModeGroup",
            "displayName": "",
            "groupStyle": "NO_ZIPPY",
            "subParams": [
              {
                "type": "RADIO",
                "name": "consentModeReports",
                "displayName": "What Google Consent Mode can report",
                "radioItems": [
                  {
                    "value": "optOutOnly",
                    "displayValue": "Opt-out only (granted counts as unknown)"
                  },
                  {
                    "value": "all",
                    "displayValue": "Opt-out and did not opt out (granted counts as did not opt out)"
                  }
                ],
                "simpleValueType": true,
                "defaultValue": "optOutOnly",
                "help": "Many US websites set \u003ci\u003ead_storage\u003c/i\u003e to granted by default, so granted usually does not mean the visitor made a choice.\u003cul\u003e\u003cli\u003e\u003cb\u003eOpt-out only\u003c/b\u003e: denied is an opt-out and granted is unknown. Google Consent Mode never overrides another signal or the \u003cb\u003eTreat as opted out (fail closed)\u003c/b\u003e setting.\u003c/li\u003e\u003cli\u003e\u003cb\u003eOpt-out and did not opt out\u003c/b\u003e: granted counts as an explicit \"did not opt out\". It can decide the result in the \u003cb\u003eFirst signal with a clear answer wins\u003c/b\u003e mode, and it prevents \u003cb\u003efail closed\u003c/b\u003e from treating the visitor as opted out.\u003c/li\u003e\u003c/ul\u003e"
              },
              {
                "type": "CHECKBOX",
                "name": "consentModeUseNpa",
                "checkboxText": "Treat x-ga-npa \u003d 1 (ads personalization disabled) as an opt-out",
                "simpleValueType": true,
                "defaultValue": false,
                "help": "The Google tag sets \u003ci\u003enpa\u003d1\u003c/i\u003e when ads personalization is off: \u003ci\u003ead_personalization\u003c/i\u003e is denied, \u003ci\u003eallow_ad_personalization_signals\u003c/i\u003e is false, or GPC is honored by the Google tag\u0027s region settings."
              },
              {
                "type": "CHECKBOX",
                "name": "consentModeUseRdp",
                "checkboxText": "Treat restricted data processing set on the website as an opt-out",
                "simpleValueType": true,
                "defaultValue": false,
                "help": "Reads \u003ci\u003ex-sst-system_properties.rdp\u003c/i\u003e, which the Google tag sends when \u003ci\u003erestricted_data_processing\u003c/i\u003e is set to true."
              }
            ],
            "enablingConditions": [
              {
                "paramName": "enableConsentMode",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "regionGroup",
    "displayName": "Region Rules",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "RADIO",
        "name": "regionScope",
        "displayName": "Apply opt-out logic to",
        "radioItems": [
          {
            "value": "us",
            "displayValue": "All United States traffic"
          },
          {
            "value": "states",
            "displayValue": "Selected US states"
          },
          {
            "value": "everywhere",
            "displayValue": "All traffic, any country"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "us",
        "help": "Outside this scope the decision is always \u003ci\u003eallow\u003c/i\u003e, with the reason \u003ci\u003eregion_not_applicable\u003c/i\u003e."
      },
      {
        "type": "TEXT",
        "name": "regionStates",
        "displayName": "US states (comma-separated 2-letter codes)",
        "simpleValueType": true,
        "defaultValue": "CA,CO,CT,DE,FL,IA,IN,KY,MD,MN,MT,NE,NH,NJ,OR,RI,TN,TX,UT,VA",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "The default list holds the states with comprehensive privacy laws, which are also the states with a GPP section. Review it with your legal team.",
        "enablingConditions": [
          {
            "paramName": "regionScope",
            "paramValue": "states",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "unknownGeoBehavior",
        "displayName": "When the location is unknown",
        "radioItems": [
          {
            "value": "apply",
            "displayValue": "Apply opt-out logic"
          },
          {
            "value": "skip",
            "displayValue": "Do not apply (allow)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "apply",
        "enablingConditions": [
          {
            "paramName": "regionScope",
            "paramValue": "everywhere",
            "type": "NOT_EQUALS"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "geoSource",
        "displayName": "Visitor location source",
        "radioItems": [
          {
            "value": "auto",
            "displayValue": "Automatic"
          },
          {
            "value": "custom",
            "displayValue": "Custom variables",
            "subParams": [
              {
                "type": "TEXT",
                "name": "customCountry",
                "displayName": "Country (ISO 3166-1 alpha-2)",
                "simpleValueType": true
              },
              {
                "type": "TEXT",
                "name": "customRegion",
                "displayName": "Region (state code, e.g. CA or US-CA)",
                "simpleValueType": true
              }
            ]
          }
        ],
        "simpleValueType": true,
        "defaultValue": "auto",
        "help": "The visitor location is used by the region rules, by the Meta \u003cb\u003eUnited States\u003c/b\u003e mode (Meta state codes) and in the \u003cb\u003eFull object\u003c/b\u003e, so it is read even when the opt-out logic applies to all traffic.\u003cbr/\u003e\u003cbr/\u003e\u003cb\u003eAutomatic\u003c/b\u003e reads country and region together from the first source that has a country:\u003col\u003e\u003cli\u003eEvent Data \u003ci\u003eevent_location\u003c/i\u003e (sent by the Google tag as the \u003ci\u003eur\u003c/i\u003e parameter).\u003c/li\u003e\u003cli\u003eStape GEO Headers power-up: \u003ci\u003eX-GEO-Country\u003c/i\u003e / \u003ci\u003eX-GEO-Region\u003c/i\u003e.\u003c/li\u003e\u003cli\u003eGoogle Cloud load balancer: \u003ci\u003eX-Gclb-Country\u003c/i\u003e / \u003ci\u003eX-Gclb-Region\u003c/i\u003e.\u003c/li\u003e\u003cli\u003eAWS CloudFront: \u003ci\u003eCloudFront-Viewer-Country\u003c/i\u003e / \u003ci\u003eCloudFront-Viewer-Country-Region\u003c/i\u003e.\u003c/li\u003e\u003cli\u003eGoogle App Engine: \u003ci\u003eX-AppEngine-Country\u003c/i\u003e / \u003ci\u003eX-AppEngine-Region\u003c/i\u003e.\u003c/li\u003e\u003cli\u003eAzure Front Door: \u003ci\u003eX-Azure-Country\u003c/i\u003e (country only).\u003c/li\u003e\u003cli\u003eCloudflare: \u003ci\u003eCF-IPCountry\u003c/i\u003e (country only).\u003c/li\u003e\u003c/ol\u003e"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "metaGroup",
    "displayName": "Meta Limited Data Use",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "RADIO",
        "name": "metaDpoMode",
        "displayName": "Country and state values when restricted",
        "radioItems": [
          {
            "value": "geolocation",
            "displayValue": "Let Meta geolocate (country 0, state 0)"
          },
          {
            "value": "us",
            "displayValue": "United States (country 1; the Meta state code for supported states, otherwise 0)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "geolocation",
        "help": "Values returned for \u003ci\u003edata_processing_options_country\u003c/i\u003e and \u003ci\u003edata_processing_options_state\u003c/i\u003e when the decision is restricted. When it is \u003ci\u003eallow\u003c/i\u003e, both are \u003ci\u003eundefined\u003c/i\u003e and \u003ci\u003edata_processing_options\u003c/i\u003e is \u003ci\u003e[]\u003c/i\u003e.\u003cbr/\u003e\u003cbr/\u003e\u003cb\u003eUnited States\u003c/b\u003e uses the visitor location for the state: 1000 California, 1001 Colorado, 1002 Connecticut, 1003 Florida, 1004 Oregon, 1005 Texas, 1006 Montana, 1007 Delaware, 1008 Nebraska, 1009 New Hampshire, 1010 New Jersey, 1011 Minnesota, 1012 Maryland, 1013 Rhode Island. Other states, and visitors outside the US, get 0, which lets Meta geolocate the state. Use this mode only when the region rules are limited to the US."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "returnType",
        "paramValue": "metaDpoCountry",
        "type": "EQUALS"
      },
      {
        "paramName": "returnType",
        "paramValue": "metaDpoState",
        "type": "EQUALS"
      },
      {
        "paramName": "returnType",
        "paramValue": "object",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const createRegex = require('createRegex');
const decodeUriComponent = require('decodeUriComponent');
const getAllEventData = require('getAllEventData');
const getCookieValues = require('getCookieValues');
const getRequestHeader = require('getRequestHeader');
const getType = require('getType');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
const testRegex = require('testRegex');

/*==============================================================================
==============================================================================*/

const OPT_OUT = 'opt_out';
const NO_OPT_OUT = 'no_opt_out';
const UNKNOWN = 'unknown';
const DISABLED = 'disabled';
const SIGNAL_NAMES = ['gpc', 'gpp', 'us_privacy', 'cmp', 'consent_mode'];
const MAX_GPP_SECTION_ID = 1000;
const TRUSTARC_NOT_PROVISIONED = '100';

const GPP_SECTIONS = {
  6: { name: 'uspv1' },
  7: {
    name: 'usnat',
    versions: [1, 2],
    fields: [
      { name: 'sale', offset: 18 },
      { name: 'sharing', offset: 20 },
      { name: 'targeted_advertising', offset: 22 }
    ],
    hasGpcSegment: true
  },
  8: {
    name: 'usca',
    versions: [1],
    fields: [
      { name: 'sale', offset: 12 },
      { name: 'sharing', offset: 14 }
    ],
    hasGpcSegment: true
  },
  9: saleAndTargetedSection('usva', 12, false),
  10: saleAndTargetedSection('usco', 12, true),
  11: saleAndTargetedSection('usut', 14, false),
  12: saleAndTargetedSection('usct', 12, true),
  13: saleAndTargetedSection('usfl', 12, false),
  14: saleAndTargetedSection('usmt', 12, true),
  15: saleAndTargetedSection('usor', 12, true),
  16: saleAndTargetedSection('ustx', 12, true),
  17: saleAndTargetedSection('usde', 12, true),
  18: saleAndTargetedSection('usia', 14, true),
  19: saleAndTargetedSection('usne', 12, true),
  20: saleAndTargetedSection('usnh', 12, true),
  21: saleAndTargetedSection('usnj', 12, true),
  22: saleAndTargetedSection('ustn', 12, true),
  23: saleAndTargetedSection('usmn', 12, true),
  24: saleAndTargetedSection('usmd', 16, true),
  25: saleAndTargetedSection('usin', 16, false),
  26: saleAndTargetedSection('usky', 16, false),
  27: saleAndTargetedSection('usri', 16, false)
};

const META_STATE_CODES = {
  CA: 1000,
  CO: 1001,
  CT: 1002,
  FL: 1003,
  OR: 1004,
  TX: 1005,
  MT: 1006,
  DE: 1007,
  NE: 1008,
  NH: 1009,
  NJ: 1010,
  MN: 1011,
  MD: 1012,
  RI: 1013
};

const GCD_ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_';
const GCD_CONSENT_TYPES = ['ad_storage', 'analytics_storage', 'ad_user_data', 'ad_personalization'];
const OPT_OUT_CONSENT_TYPES = ['ad_storage', 'ad_user_data', 'ad_personalization'];

const US_STATE_CODES = {
  alabama: 'AL',
  alaska: 'AK',
  arizona: 'AZ',
  arkansas: 'AR',
  california: 'CA',
  colorado: 'CO',
  connecticut: 'CT',
  delaware: 'DE',
  'district of columbia': 'DC',
  florida: 'FL',
  georgia: 'GA',
  hawaii: 'HI',
  idaho: 'ID',
  illinois: 'IL',
  indiana: 'IN',
  iowa: 'IA',
  kansas: 'KS',
  kentucky: 'KY',
  louisiana: 'LA',
  maine: 'ME',
  maryland: 'MD',
  massachusetts: 'MA',
  michigan: 'MI',
  minnesota: 'MN',
  mississippi: 'MS',
  missouri: 'MO',
  montana: 'MT',
  nebraska: 'NE',
  nevada: 'NV',
  'new hampshire': 'NH',
  'new jersey': 'NJ',
  'new mexico': 'NM',
  'new york': 'NY',
  'north carolina': 'NC',
  'north dakota': 'ND',
  ohio: 'OH',
  oklahoma: 'OK',
  oregon: 'OR',
  pennsylvania: 'PA',
  'rhode island': 'RI',
  'south carolina': 'SC',
  'south dakota': 'SD',
  tennessee: 'TN',
  texas: 'TX',
  utah: 'UT',
  vermont: 'VT',
  virginia: 'VA',
  washington: 'WA',
  'west virginia': 'WV',
  wisconsin: 'WI',
  wyoming: 'WY'
};

const eventData = getAllEventData() || {};
const gcd = decodeGcd(eventData['x-ga-gcd']);

const geo = getGeo(data, eventData);
const applies = isRegionApplicable(data, geo);

const signalResults = {
  gpc: isUIFieldTrue(data.enableGpc) ? evaluateGpc(gcd) : { status: DISABLED },
  gpp: isUIFieldTrue(data.enableGpp) ? evaluateGpp(data, eventData) : { status: DISABLED },
  us_privacy: isUIFieldTrue(data.enableUsPrivacy)
    ? evaluateUsPrivacy(data, eventData)
    : { status: DISABLED },
  cmp: isUIFieldTrue(data.enableCmp) ? evaluateCmp(data) : { status: DISABLED },
  consent_mode: isUIFieldTrue(data.enableConsentMode)
    ? evaluateConsentMode(data, eventData, gcd)
    : { status: DISABLED }
};

const resolution = resolveSignals(data, signalResults);
const result = buildResult(data, geo, applies, resolution, signalResults);

return getReturnValue(data, result);

/*==============================================================================
  Signal evaluation
==============================================================================*/

function evaluateGpc(gcd) {
  const header = getRequestHeader('sec-gpc');
  const value = isValidValue(header) ? makeString(header).split(',')[0].trim() : undefined;
  if (value === '1') return { status: OPT_OUT, value: value, source: 'sec-gpc' };
  if (gcd && gcd.gpc) return { status: OPT_OUT, value: value, source: 'x-ga-gcd' };
  return { status: UNKNOWN, value: value };
}

function evaluateUsPrivacy(data, eventData) {
  const source = getFirstValid([
    [data.usPrivacyString, 'variable'],
    [getSystemProperty(eventData, 'us_privacy'), 'x-sst-system_properties.us_privacy'],
    [eventData['x-ads-us_privacy'], 'x-ads-us_privacy'],
    [getCookieValues('usprivacy')[0], 'cookie_usprivacy'],
    [getCookieValues('us_privacy')[0], 'cookie_us_privacy']
  ]);
  if (!source) return { status: UNKNOWN };
  return {
    status: parseUsPrivacyString(source.value),
    value: makeString(source.value),
    source: source.source
  };
}

function evaluateGpp(data, eventData) {
  const gppSource = getFirstValid([
    [data.gppString, 'variable'],
    [getSystemProperty(eventData, 'gpp'), 'x-sst-system_properties.gpp'],
    [eventData['x-ads-gpp'], 'x-ads-gpp'],
    [getCookieValues('OTGPPConsent')[0], 'cookie_OTGPPConsent']
  ]);
  if (!gppSource) return { status: UNKNOWN };

  const sidSource = getFirstValid([
    [data.gppSid, 'variable'],
    [getSystemProperty(eventData, 'gpp_sid'), 'x-sst-system_properties.gpp_sid'],
    [eventData['x-ads-gpp_sid'], 'x-ads-gpp_sid']
  ]);
  const applicableSids = sidSource ? parseSidList(sidSource.value) : undefined;

  const decoded = decodeGppString(makeString(gppSource.value));
  if (!decoded) {
    return {
      status: UNKNOWN,
      value: makeString(gppSource.value),
      source: gppSource.source,
      error: 'invalid_gpp_string'
    };
  }

  const considered = decoded.filter((section) => {
    return !applicableSids || applicableSids.indexOf(section.id) !== -1;
  });

  return {
    status: combineStatuses(considered.map((section) => section.status)),
    value: makeString(gppSource.value),
    source: gppSource.source,
    applicable_sections: applicableSids,
    sections: decoded
  };
}

function evaluateCmp(data) {
  const preset = data.cmpPreset;
  if (preset === 'onetrust') return evaluateOneTrust(data);
  if (preset === 'cookiebot') return evaluateCookiebot();
  if (preset === 'trustarc') return evaluateTrustArc(data);
  if (preset === 'custom') return evaluateCustomCookie(data);
  return { status: UNKNOWN, preset: preset };
}

function evaluateConsentMode(data, eventData, gcd) {
  const result = readConsentState(eventData.consent_state) ||
    readGcdConsent(gcd, eventData['x-ga-gcd']) ||
    readGcs(eventData['x-ga-gcs']) || { status: UNKNOWN };

  if (result.status !== OPT_OUT && isUIFieldTrue(data.consentModeUseNpa)) {
    const npa = eventData['x-ga-npa'];
    if (npa === '1' || npa === 1 || npa === true) {
      result.status = OPT_OUT;
      result.source = 'x-ga-npa';
    }
  }

  if (result.status !== OPT_OUT && isUIFieldTrue(data.consentModeUseRdp)) {
    const rdp = getSystemProperty(eventData, 'rdp');
    if (rdp === true || rdp === '1' || rdp === 1) {
      result.status = OPT_OUT;
      result.source = 'x-sst-system_properties.rdp';
    }
  }

  if (result.status === NO_OPT_OUT && data.consentModeReports !== 'all') {
    result.status = UNKNOWN;
    result.granted_reported_as_unknown = true;
  }

  return result;
}

function readConsentState(consentState) {
  if (getType(consentState) !== 'object') return undefined;
  const states = {};
  OPT_OUT_CONSENT_TYPES.forEach((type) => {
    if (consentState[type] === true) states[type] = 'granted';
    else if (consentState[type] === false) states[type] = 'denied';
  });
  return consentStatesToResult(states, 'consent_state');
}

function readGcdConsent(gcd, rawGcd) {
  if (!gcd) return undefined;
  const states = {};
  OPT_OUT_CONSENT_TYPES.forEach((type) => {
    if (gcd.states[type]) states[type] = gcd.states[type];
  });
  const result = consentStatesToResult(states, 'x-ga-gcd');
  if (result) result.value = makeString(rawGcd);
  return result;
}

function readGcs(rawGcs) {
  const gcs = makeString(rawGcs || '');
  const adStorage = gcs.indexOf('G1') === 0 ? gcs.charAt(2) : '';
  const states = {};
  if (adStorage === '0') states.ad_storage = 'denied';
  else if (adStorage === '1') states.ad_storage = 'granted';
  const result = consentStatesToResult(states, 'x-ga-gcs');
  if (result) result.value = gcs;
  return result;
}

function consentStatesToResult(states, source) {
  let status;
  if (OPT_OUT_CONSENT_TYPES.some((type) => states[type] === 'denied')) status = OPT_OUT;
  else if (states.ad_storage === 'granted') status = NO_OPT_OUT;
  if (!status) return undefined;
  return { status: status, source: source, states: states };
}

/*==============================================================================
  Resolution and output
==============================================================================*/

function resolveSignals(data, signalResults) {
  const order = getSignalOrder(data);
  const priorityMode = data.resolutionMode === 'priority';

  for (let i = 0; i < order.length; i++) {
    const name = order[i];
    const status = signalResults[name].status;
    if (status === OPT_OUT) return { optedOut: true, decidedBy: name };
    if (priorityMode && status === NO_OPT_OUT) return { optedOut: false, decidedBy: name };
  }

  const hasClearAnswer = order.some((name) => signalResults[name].status === NO_OPT_OUT);
  if (!hasClearAnswer && data.noSignalBehavior === 'optOut') {
    return { optedOut: true, decidedBy: 'no_clear_signal' };
  }
  return { optedOut: false, decidedBy: undefined };
}

function buildResult(data, geo, applies, resolution, signalResults) {
  const restrictedAction = data.optOutAction === 'block' ? 'block' : 'limited';
  const decision = applies && resolution.optedOut ? restrictedAction : 'allow';
  const restricted = decision !== 'allow';

  let reason;
  if (!applies) reason = 'region_not_applicable';
  else if (resolution.decidedBy) reason = resolution.decidedBy;
  else reason = 'no_opt_out_signal';

  const signals = {};
  SIGNAL_NAMES.forEach((name) => {
    signals[name] = signalResults[name].status;
  });

  return {
    decision: decision,
    restricted: restricted,
    opted_out: resolution.optedOut,
    reason: reason,
    applies: applies,
    country: geo.country,
    region: geo.region,
    geo_source: geo.source,
    signals: signals,
    details: signalResults,
    vendor: buildVendorFlags(data, geo, restricted)
  };
}

function buildVendorFlags(data, geo, restricted) {
  let metaCountry;
  let metaState;
  if (restricted) {
    const explicitUs = data.metaDpoMode === 'us';
    metaCountry = explicitUs ? 1 : 0;
    metaState = explicitUs && geo.country === 'US' ? META_STATE_CODES[geo.region] || 0 : 0;
  }

  return {
    meta: {
      data_processing_options: restricted ? ['LDU'] : [],
      data_processing_options_country: metaCountry,
      data_processing_options_state: metaState
    },
    google_ads: { restricted_data_processing: restricted },
    tiktok: { limited_data_use: restricted }
  };
}

function getReturnValue(data, result) {
  const vendor = result.vendor;
  switch (data.returnType) {
    case 'restricted':
      return result.restricted;
    case 'object':
      return result;
    case 'metaDpo':
      return vendor.meta.data_processing_options;
    case 'metaDpoCountry':
      return vendor.meta.data_processing_options_country;
    case 'metaDpoState':
      return vendor.meta.data_processing_options_state;
    case 'googleAdsRdp':
      return vendor.google_ads.restricted_data_processing;
    case 'tiktokLdu':
      return vendor.tiktok.limited_data_use;
    default:
      return result.decision;
  }
}

function getSignalOrder(data) {
  const order = [];
  const rows = getType(data.signalPriority) === 'array' ? data.signalPriority : [];
  rows.forEach((row) => {
    const name = row && row.signal;
    if (SIGNAL_NAMES.indexOf(name) !== -1 && order.indexOf(name) === -1) order.push(name);
  });
  SIGNAL_NAMES.forEach((name) => {
    if (order.indexOf(name) === -1) order.push(name);
  });
  return order;
}

/*==============================================================================
  Geo
==============================================================================*/

function getGeo(data, eventData) {
  if (data.geoSource === 'custom') {
    return normalizeGeo(data.customCountry, data.customRegion, 'custom');
  }

  const location = eventData.event_location;
  if (getType(location) === 'object' && isKnownCountry(location.country)) {
    return normalizeGeo(location.country, location.region, 'event_location');
  }

  const headerSources = [
    { country: 'x-geo-country', region: 'x-geo-region', source: 'x-geo' },
    { country: 'x-gclb-country', region: 'x-gclb-region', source: 'x-gclb' },
    {
      country: 'cloudfront-viewer-country',
      region: 'cloudfront-viewer-country-region',
      source: 'cloudfront'
    },
    { country: 'x-appengine-country', region: 'x-appengine-region', source: 'appengine' },
    { country: 'x-azure-country', source: 'azure' },
    { country: 'cf-ipcountry', source: 'cf' }
  ];
  for (let i = 0; i < headerSources.length; i++) {
    const headerSource = headerSources[i];
    const country = getRequestHeader(headerSource.country);
    if (isKnownCountry(country)) {
      const region = headerSource.region ? getRequestHeader(headerSource.region) : undefined;
      return normalizeGeo(country, region, headerSource.source);
    }
  }

  return { country: undefined, region: undefined, source: 'none' };
}

function normalizeGeo(country, region, source) {
  const normalizedCountry = isKnownCountry(country)
    ? makeString(country).trim().toUpperCase()
    : undefined;
  return {
    country: normalizedCountry,
    region: normalizeRegion(region, normalizedCountry),
    source: source
  };
}

function normalizeRegion(region, country) {
  if (!isValidValue(region)) return undefined;
  const value = makeString(region).trim();
  if (!value) return undefined;
  const upper = value.toUpperCase();

  if (country && upper.indexOf(country + '-') === 0) return upper.slice(country.length + 1);
  if (country === 'US' && upper.length === 4 && upper.indexOf('US') === 0) return upper.slice(2);
  if (upper.length <= 3) return upper;

  if (!country || country === 'US') {
    const stateCode = US_STATE_CODES[value.toLowerCase()];
    if (stateCode) return stateCode;
  }
  return upper;
}

function isKnownCountry(country) {
  if (!isValidValue(country)) return false;
  const value = makeString(country).trim().toUpperCase();
  return value.length === 2 && value !== 'XX' && value !== 'ZZ';
}

function isRegionApplicable(data, geo) {
  const scope = data.regionScope || 'us';
  const applyWhenUnknown = data.unknownGeoBehavior !== 'skip';

  if (scope === 'everywhere') return true;
  if (!geo.country) return applyWhenUnknown;
  if (geo.country !== 'US') return false;
  if (scope === 'us') return true;

  if (!geo.region) return applyWhenUnknown;
  return parseList(data.regionStates).indexOf(geo.region) !== -1;
}

/*==============================================================================
  Vendor related functions
==============================================================================*/

function evaluateOneTrust(data) {
  const raw = getCookieValues('OptanonConsent')[0];
  if (!isValidValue(raw)) return { status: UNKNOWN, preset: 'onetrust', cookie_found: false };

  const category = makeString(data.oneTrustCategory || 'C0004').trim();
  const decoded = safeDecode(raw);
  const groups = getQueryLikeParam(decoded, 'groups');
  let status = UNKNOWN;
  if (groups) {
    safeDecode(groups)
      .split(',')
      .forEach((entry) => {
        const parts = entry.trim().split(':');
        if (parts[0] !== category) return;
        if (parts[1] === '0') status = OPT_OUT;
        else if (parts[1] === '1') status = NO_OPT_OUT;
      });
  }

  const browserGpc = makeString(getQueryLikeParam(decoded, 'browserGpcFlag') || '').trim() === '1';
  if (browserGpc) status = OPT_OUT;

  return {
    status: status,
    preset: 'onetrust',
    cookie_found: true,
    category: category,
    browser_gpc: browserGpc
  };
}

function evaluateCookiebot() {
  const raw = getCookieValues('CookieConsent')[0];
  if (!isValidValue(raw)) return { status: UNKNOWN, preset: 'cookiebot', cookie_found: false };

  const value = safeDecode(raw).split(' ').join('').split('"').join('').split("'").join('');
  let status = UNKNOWN;
  if (value.indexOf('marketing:false') !== -1) status = OPT_OUT;
  else if (value.indexOf('marketing:true') !== -1) status = NO_OPT_OUT;
  return { status: status, preset: 'cookiebot', cookie_found: true };
}

function evaluateTrustArc(data) {
  const advertisingIndex = makeString(
    isValidValue(data.trustArcCategory) ? data.trustArcCategory : 2
  );

  const gdprPrefs = getCookieValues('notice_gdpr_prefs')[0];
  if (isValidValue(gdprPrefs)) {
    const categories = safeDecode(gdprPrefs)
      .split(':')[0]
      .split(',')
      .map((entry) => entry.trim());
    let status = categories.indexOf(advertisingIndex) !== -1 ? NO_OPT_OUT : OPT_OUT;
    if (!categories.every(isDigits) || categories.indexOf(TRUSTARC_NOT_PROVISIONED) !== -1) {
      status = UNKNOWN;
    }
    return trustArcResult(status, 'notice_gdpr_prefs');
  }

  const preferences = getCookieValues('notice_preferences')[0];
  if (isValidValue(preferences)) {
    const level = safeDecode(preferences).split(':')[0].trim();
    let status = UNKNOWN;
    if (isDigits(level) && level !== TRUSTARC_NOT_PROVISIONED) {
      status = makeInteger(level) >= makeInteger(advertisingIndex) ? NO_OPT_OUT : OPT_OUT;
    }
    return trustArcResult(status, 'notice_preferences');
  }

  return { status: UNKNOWN, preset: 'trustarc', cookie_found: false };
}

function trustArcResult(status, cookie) {
  return { status: status, preset: 'trustarc', cookie_found: true, cookie: cookie };
}

function evaluateCustomCookie(data) {
  const cookieName = makeString(data.cmpCustomCookieName || '').trim();
  if (!cookieName) return { status: UNKNOWN, preset: 'custom', cookie_found: false };

  const raw = getCookieValues(cookieName)[0];
  if (!isValidValue(raw)) {
    return { status: UNKNOWN, preset: 'custom', cookie: cookieName, cookie_found: false };
  }

  const value = makeString(raw);
  let status = UNKNOWN;
  if (matchesCookieValue(value, data.cmpCustomMatchType, data.cmpCustomOptOutValue)) {
    status = OPT_OUT;
  } else if (matchesCookieValue(value, data.cmpCustomMatchType, data.cmpCustomOptInValue)) {
    status = NO_OPT_OUT;
  }
  return { status: status, preset: 'custom', cookie: cookieName, cookie_found: true };
}

function matchesCookieValue(value, matchType, expected) {
  if (!isValidValue(expected)) return false;
  const pattern = makeString(expected);
  if (matchType === 'contains') return value.indexOf(pattern) !== -1;
  if (matchType === 'regex') {
    const regex = createRegex(pattern, 'i');
    return regex ? testRegex(regex, value) : false;
  }
  return value === pattern;
}

function parseUsPrivacyString(value) {
  const usp = makeString(value).trim().toUpperCase();
  if (usp.length !== 4 || usp.charAt(0) !== '1') return UNKNOWN;
  const optOut = usp.charAt(2);
  if (optOut === 'Y') return OPT_OUT;
  if (optOut === 'N') return NO_OPT_OUT;
  return UNKNOWN;
}

/*==============================================================================
  GPP decoding (IAB Global Privacy Platform)
==============================================================================*/

function decodeGppString(gppString) {
  const parts = gppString.trim().split('~');
  const sectionIds = decodeGppHeader(parts[0]);
  if (!sectionIds) return undefined;

  const sections = [];
  for (let i = 0; i < sectionIds.length; i++) {
    const encodedSection = parts[i + 1];
    if (!isValidValue(encodedSection)) break;
    sections.push(decodeGppSection(sectionIds[i], encodedSection));
  }
  return sections;
}

function decodeGppHeader(encodedHeader) {
  const sextets = base64ToSextets(encodedHeader);
  if (!sextets || readBitsInt(sextets, 0, 6) !== 3) return undefined;

  const entries = readBitsInt(sextets, 12, 12);
  if (entries === undefined) return undefined;

  const ids = [];
  let position = 24;
  let lastId = 0;
  for (let i = 0; i < entries; i++) {
    if (position >= sextets.length * 6) return undefined;
    const isRange = readBit(sextets, position) === 1;
    position++;

    const offset = readFibonacci(sextets, position);
    if (!offset) return undefined;
    position = offset.next;
    const startId = lastId + offset.value;
    if (startId > MAX_GPP_SECTION_ID) return undefined;

    if (isRange) {
      const length = readFibonacci(sextets, position);
      if (!length) return undefined;
      position = length.next;
      const endId = startId + length.value;
      if (endId > MAX_GPP_SECTION_ID) return undefined;
      for (let id = startId; id <= endId; id++) ids.push(id);
      lastId = endId;
    } else {
      ids.push(startId);
      lastId = startId;
    }
  }
  return ids;
}

function decodeGppSection(sectionId, encodedSection) {
  const definition = GPP_SECTIONS[sectionId];
  if (!definition) return { id: sectionId, status: UNKNOWN, supported: false };

  if (definition.name === 'uspv1') {
    return {
      id: sectionId,
      name: 'uspv1',
      value: encodedSection,
      status: parseUsPrivacyString(encodedSection)
    };
  }

  const segments = encodedSection.split('.');
  const core = base64ToSextets(segments[0]);
  const version = core ? readBitsInt(core, 0, 6) : undefined;
  const section = { id: sectionId, name: definition.name, version: version };

  if (!core || definition.versions.indexOf(version) === -1) {
    section.status = UNKNOWN;
    section.supported = false;
    return section;
  }

  const statuses = [];
  definition.fields.forEach((field) => {
    const fieldValue = readBitsInt(core, field.offset, 2);
    section[field.name + '_opt_out'] = fieldValue;
    statuses.push(optOutFieldToStatus(fieldValue));
  });

  if (definition.hasGpcSegment) {
    for (let i = 1; i < segments.length; i++) {
      const segment = base64ToSextets(segments[i]);
      if (segment && readBitsInt(segment, 0, 2) === 1) {
        section.gpc = readBit(segment, 2) === 1;
        if (section.gpc) statuses.push(OPT_OUT);
      }
    }
  }

  section.status = combineStatuses(statuses);
  return section;
}

function saleAndTargetedSection(name, saleOffset, hasGpcSegment) {
  return {
    name: name,
    versions: [1],
    fields: [
      { name: 'sale', offset: saleOffset },
      { name: 'targeted_advertising', offset: saleOffset + 2 }
    ],
    hasGpcSegment: hasGpcSegment
  };
}

function optOutFieldToStatus(value) {
  if (value === 1) return OPT_OUT;
  if (value === 2) return NO_OPT_OUT;
  return UNKNOWN;
}

function base64ToSextets(value) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  if (!isValidValue(value)) return undefined;
  const text = makeString(value);
  if (!text) return undefined;

  const sextets = [];
  for (let i = 0; i < text.length; i++) {
    const char = text.charAt(i);
    let index = alphabet.indexOf(char);
    if (char === '-') index = 62;
    if (char === '_') index = 63;
    if (index === -1) return undefined;
    sextets.push(index);
  }
  return sextets;
}

function readBit(sextets, position) {
  return (sextets[(position / 6) | 0] >> (5 - (position % 6))) & 1;
}

function readBitsInt(sextets, start, length) {
  if (start + length > sextets.length * 6) return undefined;
  let value = 0;
  for (let i = start; i < start + length; i++) {
    value = (value << 1) | readBit(sextets, i);
  }
  return value;
}

function readFibonacci(sextets, start) {
  let value = 0;
  let previous = 1;
  let current = 1;
  let lastBit = 0;
  for (let i = start; i < sextets.length * 6; i++) {
    const bit = readBit(sextets, i);
    if (bit === 1 && lastBit === 1) return { value: value, next: i + 1 };
    if (bit === 1) value += current;
    const nextFibonacci = previous + current;
    previous = current;
    current = nextFibonacci;
    lastBit = bit;
  }
  return undefined;
}

function parseSidList(value) {
  if (getType(value) === 'array') {
    return value.map((item) => makeInteger(item)).filter((item) => item > 0);
  }
  return makeString(value)
    .split('_')
    .join(',')
    .split(',')
    .map((item) => item.trim())
    .filter((item) => isDigits(item))
    .map((item) => makeInteger(item))
    .filter((item) => item > 0);
}

/*==============================================================================
  gcd decoding (Google Consent Mode, GA4 x-ga-gcd)
==============================================================================*/

function decodeGcd(value) {
  if (!isValidValue(value)) return undefined;
  const text = makeString(value).trim();
  if (text.length < 10 || text.charAt(0) !== '1') return undefined;

  const chars = [];
  for (let i = 0; i < 10; i++) {
    const index = GCD_ALPHABET.indexOf(text.charAt(i));
    if (index === -1) return undefined;
    chars.push(index);
  }

  const entries = {};
  GCD_CONSENT_TYPES.forEach((type, index) => {
    const first = chars[1 + index * 2];
    const second = chars[2 + index * 2];
    entries[type] = {
      delegation: first >> 2,
      defaultState: (second >> 2) & 3,
      updateState: second & 3
    };
  });

  const states = {};
  GCD_CONSENT_TYPES.forEach((type) => {
    const state = resolveGcdState(entries, type);
    if (state) states[type] = state;
  });

  return { states: states, gpc: ((chars[9] >> 3) & 1) === 1 };
}

function resolveGcdState(entries, type) {
  let current = type;
  for (let hops = 0; hops < GCD_CONSENT_TYPES.length; hops++) {
    const delegation = entries[current].delegation;
    if (delegation < 12) break;
    current = GCD_CONSENT_TYPES[delegation - 12];
  }

  const entry = entries[current];
  const state = isGcdStateSet(entry.updateState) ? entry.updateState : entry.defaultState;
  if (state === 3) return 'granted';
  if (state === 2) return 'denied';
  return undefined;
}

function isGcdStateSet(state) {
  return state === 2 || state === 3;
}

/*==============================================================================
  Helpers
==============================================================================*/

function combineStatuses(statuses) {
  if (statuses.indexOf(OPT_OUT) !== -1) return OPT_OUT;
  if (statuses.indexOf(NO_OPT_OUT) !== -1) return NO_OPT_OUT;
  return UNKNOWN;
}

function getSystemProperty(eventData, key) {
  const properties = eventData['x-sst-system_properties'];
  if (getType(properties) === 'object' && isValidValue(properties[key])) return properties[key];
  return eventData['x-sst-system_properties.' + key];
}

function getFirstValid(candidates) {
  for (let i = 0; i < candidates.length; i++) {
    if (isValidValue(candidates[i][0])) {
      return { value: candidates[i][0], source: candidates[i][1] };
    }
  }
  return undefined;
}

function getQueryLikeParam(value, name) {
  const pairs = value.split('&');
  for (let i = 0; i < pairs.length; i++) {
    const separatorIndex = pairs[i].indexOf('=');
    if (separatorIndex !== -1 && pairs[i].slice(0, separatorIndex).trim() === name) {
      return pairs[i].slice(separatorIndex + 1);
    }
  }
  return undefined;
}

function safeDecode(value) {
  const text = makeString(value);
  if (text.indexOf('%') === -1) return text;
  return decodeUriComponent(text) || text;
}

function parseList(value) {
  if (!isValidValue(value)) return [];
  return makeString(value)
    .split(',')
    .map((item) => item.trim().toUpperCase())
    .filter((item) => item.length > 0);
}

function isDigits(value) {
  if (!value) return false;
  for (let i = 0; i < value.length; i++) {
    if ('0123456789'.indexOf(value.charAt(i)) === -1) return false;
  }
  return true;
}

function isUIFieldTrue(field) {
  return [true, 'true'].indexOf(field) !== -1;
}

function isValidValue(value) {
  const valueType = getType(value);
  if (valueType === 'null' || valueType === 'undefined' || value !== value) return false;
  return value !== '' && value !== 'undefined' && value !== 'null';
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-gpc"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-geo-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-geo-region"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gclb-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gclb-region"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cloudfront-viewer-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cloudfront-viewer-country-region"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-appengine-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-appengine-region"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-azure-country"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cf-ipcountry"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: '[Default] No signal returns allow, and GPC returns limited with vendor flags'
  code: |-
    assertThat(run({}, { returnType: undefined })).isEqualTo('allow');

    let result = run({});
    assertThat([result.decision, result.restricted, result.opted_out, result.reason, result.applies]).isEqualTo(['allow', false, false, 'no_opt_out_signal', true]);
    assertThat(result.signals).isEqualTo({ gpc: 'unknown', gpp: 'unknown', us_privacy: 'unknown', cmp: 'disabled', consent_mode: 'disabled' });
    assertThat(result.vendor).isEqualTo({
      meta: { data_processing_options: [], data_processing_options_country: undefined, data_processing_options_state: undefined },
      google_ads: { restricted_data_processing: false },
      tiktok: { limited_data_use: false }
    });

    result = run(gpcHeader);
    assertThat([result.decision, result.restricted, result.opted_out, result.reason]).isEqualTo(['limited', true, true, 'gpc']);
    assertThat(result.details.gpc).isEqualTo({ status: 'opt_out', value: '1', source: 'sec-gpc' });
    assertThat(result.vendor).isEqualTo({
      meta: { data_processing_options: ['LDU'], data_processing_options_country: 0, data_processing_options_state: 0 },
      google_ads: { restricted_data_processing: true },
      tiktok: { limited_data_use: true }
    });
- name: '[GPC] Reads Sec-GPC, falls back to the GPC flag in x-ga-gcd'
  code: |-
    [['1, 1', 'opt_out'], [' 1 ', 'opt_out'], ['0', 'unknown'], ['true', 'unknown'], ['', 'unknown'], [undefined, 'unknown']].forEach((c) => {
      assertThat(run({ headers: { 'sec-gpc': c[0] } }).signals.gpc).isEqualTo(c[1]);
    });
    assertThat(run(gpcHeader, { enableGpc: false }).signals.gpc).isEqualTo('disabled');

    [
      [{}, gcd.gpcOnly, 'opt_out', 'x-ga-gcd'],
      [{}, gcd.gpc, 'opt_out', 'x-ga-gcd'],
      [{ 'sec-gpc': '1' }, gcd.gpc, 'opt_out', 'sec-gpc'],
      [{ 'sec-gpc': '0' }, gcd.gpc, 'opt_out', 'x-ga-gcd'],
      [{}, gcd.none, 'unknown', undefined],
      [{}, '1!!!!!!!!!!!', 'unknown', undefined]
    ].forEach((c) => {
      const result = run({ headers: c[0], eventData: usEventData({ 'x-ga-gcd': c[1] }) });
      assertThat([result.signals.gpc, result.details.gpc.source]).isEqualTo([c[2], c[3]]);
    });
- name: '[GPP] Decodes US National versions 1 and 2 with the GPC sub-section'
  code: |-
    [
      [fx.natSale, 'opt_out', 1, [1, 2, 2], undefined],
      [fx.natNo, 'no_opt_out', 1, [2, 2, 2], undefined],
      [fx.natTargeted, 'opt_out', 2, [2, 2, 1], undefined],
      [fx.natGpc, 'opt_out', 1, [2, 2, 2], true],
      [fx.natGpcFalse, 'no_opt_out', 1, [2, 2, 2], false],
      [fx.natNa, 'unknown', 1, [0, 0, 0], undefined],
      [fx.iabNatGpc, 'opt_out', 2, [2, 2, 2], true]
    ].forEach((c) => {
      const result = run(gpp(c[0], '7'));
      const s = result.details.gpp.sections[0];
      assertThat(result.signals.gpp).isEqualTo(c[1]);
      assertThat(result.details.gpp.applicable_sections).isEqualTo([7]);
      assertThat([s.id, s.name, s.version, s.sale_opt_out, s.sharing_opt_out, s.targeted_advertising_opt_out, s.gpc]).isEqualTo([7, 'usnat', c[2], c[3][0], c[3][1], c[3][2], c[4]]);
    });
- name: '[GPP] Decodes the state sections 8 to 27 (official IAB encoder strings)'
  code: |-
    [
      ['DBABBg~BAkAAAAA', 8, 'usca', 'sharing_opt_out', 1, 'opt_out'],
      [fx.iabCaSale, 8, 'usca', 'sale_opt_out', 1, 'opt_out'],
      ['DBABRg~BAYAAAA', 9, 'usva', 'sale_opt_out', 1, 'opt_out'],
      ['DBABJg~BAkAAAA', 10, 'usco', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABFg~BAGAAAA', 11, 'usut', 'sale_opt_out', 1, 'opt_out'],
      ['DBABVg~BAoAAAA', 12, 'usct', 'sale_opt_out', 2, 'no_opt_out'],
      ['DBABAw~BAYAAABA', 13, 'usfl', 'sale_opt_out', 1, 'opt_out'],
      ['DBABQw~BAkAAABA.QA', 14, 'usmt', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABIw~BAYAAAABAA.QA', 15, 'usor', 'sale_opt_out', 1, 'opt_out'],
      ['DBABEw~BAkAAAQA.QA', 16, 'ustx', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABEw~BAoAAAQA.YA', 16, 'ustx', 'gpc', true, 'opt_out'],
      ['DBABUw~BAYAAAABAA.QA', 17, 'usde', 'sale_opt_out', 1, 'opt_out'],
      ['DBABCw~BAJAAAQA.QA', 18, 'usia', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABSw~BAYAAAQA.QA', 19, 'usne', 'sale_opt_out', 1, 'opt_out'],
      ['DBABKw~BAkAAABA.QA', 20, 'usnh', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABAYA~BAYAAAAAQA.QA', 21, 'usnj', 'sale_opt_out', 1, 'opt_out'],
      ['DBABQYA~BAkAAAQA.QA', 22, 'ustn', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABIYA~BAYAAAQA.QA', 23, 'usmn', 'sale_opt_out', 1, 'opt_out'],
      ['DBABEYA~BQCQ.QA', 24, 'usmd', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABEYA~BQCg.QA', 24, 'usmd', 'gpc', false, 'no_opt_out'],
      ['DBABUYA~BQBg.AAA', 25, 'usin', 'sale_opt_out', 1, 'opt_out'],
      ['DBABCYA~BQCQ.AAA', 26, 'usky', 'targeted_advertising_opt_out', 1, 'opt_out'],
      ['DBABSYA~BQBg.AAA', 27, 'usri', 'sale_opt_out', 1, 'opt_out']
    ].forEach((c) => {
      const result = run(gpp(c[0]));
      const s = result.details.gpp.sections[0];
      assertThat([s.id, s.name, s.version, s[c[3]], result.signals.gpp]).isEqualTo([c[1], c[2], 1, c[4], c[5]]);
    });
- name: '[GPP] Multi-section strings, range headers, uspv1 and applicable section IDs'
  code: |-
    let result = run(gpp(fx.multi));
    assertThat(result.signals.gpp).isEqualTo('opt_out');
    assertThat(result.details.gpp.sections.map((s) => [s.id, s.status, s.supported])).isEqualTo([[2, 'unknown', false], [7, 'no_opt_out', undefined], [8, 'opt_out', undefined]]);
    assertThat(run(gpp(fx.ranges)).details.gpp.sections.map((s) => s.name)).isEqualTo(['usnat', 'usca', 'usva']);
    assertThat(run(gpp(fx.iabMultiNo)).details.gpp.sections.map((s) => s.name)).isEqualTo(['uspv1', 'usnat', 'usva']);
    assertThat(run(gpp(fx.iabMultiNo)).signals.gpp).isEqualTo('no_opt_out');
    assertThat(run(gpp('DBABT~1YYN')).details.gpp.sections[0]).isEqualTo({ id: 6, name: 'uspv1', value: '1YYN', status: 'opt_out' });

    [
      ['7', 'no_opt_out', [7]],
      ['8', 'opt_out', [8]],
      ['2_7', 'no_opt_out', [2, 7]],
      ['7,8', 'opt_out', [7, 8]],
      [[7], 'no_opt_out', [7]],
      ['-1', 'unknown', []],
      [undefined, 'opt_out', undefined]
    ].forEach((c) => {
      result = run(gpp(fx.multi, c[0]));
      assertThat([result.signals.gpp, result.details.gpp.applicable_sections]).isEqualTo([c[1], c[2]]);
    });
- name: '[GPP] Source order, and invalid, unsupported or v3 strings are unknown'
  code: |-
    let result = run({ eventData: usEventData({ 'x-ads-gpp': fx.natSale, 'x-ads-gpp_sid': '7' }), cookies: { OTGPPConsent: fx.natNo } });
    assertThat([result.signals.gpp, result.details.gpp.source, result.details.gpp.applicable_sections]).isEqualTo(['opt_out', 'x-ads-gpp', [7]]);
    result = run({ cookies: { OTGPPConsent: fx.iabCaSale } });
    assertThat([result.signals.gpp, result.details.gpp.source, result.details.gpp.applicable_sections]).isEqualTo(['opt_out', 'cookie_OTGPPConsent', undefined]);
    assertThat(run(ev({ 'x-sst-system_properties.gpp': fx.natSale })).signals.gpp).isEqualTo('opt_out');
    assertThat(run(ev({ 'x-sst-system_properties': { gpp: fx.natNo }, 'x-ads-gpp': fx.natSale })).signals.gpp).isEqualTo('no_opt_out');
    result = run({}, { gppString: fx.natSale, gppSid: '8' });
    assertThat([result.details.gpp.value, result.signals.gpp]).isEqualTo([fx.natSale, 'unknown']);

    [
      ['not a gpp string!', 'invalid_gpp_string'],
      ['BBABM~1YYN', 'invalid_gpp_string'],
      ['DBAB', 'invalid_gpp_string'],
      ['DBABrlFEFUJCw~BAAqAAAAAAA', 'invalid_gpp_string'],
      ['DBABL', undefined, []],
      [fx.natV3, undefined, [[7, false]]],
      ['DBABKY~BAAAAAA', undefined, [[28, false]]]
    ].forEach((c) => {
      result = run(gpp(c[0]));
      assertThat([result.signals.gpp, result.details.gpp.error]).isEqualTo(['unknown', c[1]]);
      if (c[2]) assertThat(result.details.gpp.sections.map((s) => [s.id, s.supported])).isEqualTo(c[2]);
    });
    result = run(gpp('DBABL~BAA'));
    assertThat([result.signals.gpp, result.details.gpp.sections[0].version, result.details.gpp.sections[0].sale_opt_out]).isEqualTo(['unknown', 1, undefined]);
- name: '[US Privacy] Parses the opt-out character and reads sources in order'
  code: |-
    [['1YYN', 'opt_out'], ['1nyn', 'opt_out'], ['1YNN', 'no_opt_out'], ['1---', 'unknown'], ['2YYN', 'unknown'], ['1YY', 'unknown']].forEach((c) => {
      const result = run(ev({ 'x-sst-system_properties': { us_privacy: c[0] } }));
      assertThat([result.signals.us_privacy, result.details.us_privacy.value]).isEqualTo([c[1], c[0]]);
    });

    const both = { 'x-sst-system_properties': { us_privacy: '1YNN' }, 'x-ads-us_privacy': '1YYN' };
    [
      [{ eventData: usEventData(both), cookies: { usprivacy: '1YYN' } }, { usPrivacyString: '1YYY' }, 'variable'],
      [ev(both), {}, 'x-sst-system_properties.us_privacy'],
      [{ eventData: usEventData({ 'x-ads-us_privacy': '1YYN' }), cookies: { usprivacy: '1YNN' } }, {}, 'x-ads-us_privacy'],
      [{ cookies: { usprivacy: '1YYN', us_privacy: '1YNN' } }, {}, 'cookie_usprivacy'],
      [{ cookies: { us_privacy: '1YYN' } }, {}, 'cookie_us_privacy']
    ].forEach((c) => {
      assertThat(run(c[0], c[1]).details.us_privacy.source).isEqualTo(c[2]);
    });
    assertThat(run({}, { enableUsPrivacy: false, usPrivacyString: '1YYN' }).signals.us_privacy).isEqualTo('disabled');
- name: '[CMP] OneTrust and Cookiebot presets'
  code: |-
    [
      ['isGpcEnabled=0&datestamp=x&groups=C0001%3A1%2CC0002%3A1%2CC0004%3A0', undefined, 'opt_out', false],
      ['isGpcEnabled=0&groups=C0001:1,C0004:1&geolocation=US;CA', undefined, 'no_opt_out', false],
      ['groups=C0001:1,C0002:0', undefined, 'unknown', false],
      ['datestamp=x', undefined, 'unknown', false],
      ['groups=C0001:1,C0005:0', 'C0005', 'opt_out', false],
      ['isGpcEnabled=1&browserGpcFlag=1&groups=C0001%3A1%2CC0004%3A1', undefined, 'opt_out', true],
      ['browserGpcFlag=1&datestamp=x', undefined, 'opt_out', true],
      ['isGpcEnabled=1&browserGpcFlag=0&groups=C0004:1', undefined, 'no_opt_out', false],
      [undefined, undefined, 'unknown', undefined]
    ].forEach((c) => {
      const result = run({ cookies: { OptanonConsent: c[0] } }, { enableCmp: true, cmpPreset: 'onetrust', oneTrustCategory: c[1] });
      assertThat([result.signals.cmp, result.details.cmp.cookie_found, result.details.cmp.browser_gpc]).isEqualTo([c[2], c[0] !== undefined, c[3]]);
    });

    [
      ["{stamp:'abc',necessary:true,preferences:true,statistics:true,marketing:false,method:'explicit',ver:1}", 'opt_out'],
      ['{stamp:%27abc%27%2Cnecessary:true%2Cmarketing:true}', 'no_opt_out'],
      ['{"necessary": true, "marketing": false}', 'opt_out'],
      ['-1', 'unknown'],
      [undefined, 'unknown']
    ].forEach((c) => {
      const result = run({ cookies: { CookieConsent: c[0] } }, { enableCmp: true, cmpPreset: 'cookiebot' });
      assertThat([result.signals.cmp, result.details.cmp.preset]).isEqualTo([c[1], 'cookiebot']);
    });
- name: '[CMP] TrustArc and custom cookie presets'
  code: |-
    [
      [{ notice_gdpr_prefs: '0,1:', notice_preferences: '2:' }, undefined, 'opt_out', 'notice_gdpr_prefs'],
      [{ notice_gdpr_prefs: '0,1,2:' }, undefined, 'no_opt_out', 'notice_gdpr_prefs'],
      [{ notice_gdpr_prefs: '0,1,12:' }, undefined, 'opt_out', 'notice_gdpr_prefs'],
      [{ notice_gdpr_prefs: '100:' }, undefined, 'unknown', 'notice_gdpr_prefs'],
      [{ notice_gdpr_prefs: 'abc:' }, undefined, 'unknown', 'notice_gdpr_prefs'],
      [{ notice_preferences: '1:' }, undefined, 'opt_out', 'notice_preferences'],
      [{ notice_preferences: '2:' }, undefined, 'no_opt_out', 'notice_preferences'],
      [{ notice_preferences: '3:' }, undefined, 'no_opt_out', 'notice_preferences'],
      [{ notice_preferences: 'abc:' }, undefined, 'unknown', 'notice_preferences'],
      [{ notice_preferences: '100:' }, undefined, 'unknown', 'notice_preferences'],
      [{ notice_preferences: '1:' }, '1', 'no_opt_out', 'notice_preferences'],
      [{}, undefined, 'unknown', undefined]
    ].forEach((c) => {
      const result = run({ cookies: c[0] }, { enableCmp: true, cmpPreset: 'trustarc', trustArcCategory: c[1] });
      assertThat([result.signals.cmp, result.details.cmp.cookie]).isEqualTo([c[2], c[3]]);
    });

    [
      ['equals', 'optout', 'optout', 'optin', 'opt_out'],
      ['equals', 'optin', 'optout', 'optin', 'no_opt_out'],
      ['equals', 'other', 'optout', 'optin', 'unknown'],
      ['contains', 'sale=0|share=0', 'sale=0', undefined, 'opt_out'],
      ['regex', 'Marketing=DENIED', 'marketing=(denied|0)', undefined, 'opt_out'],
      ['regex', 'marketing=granted', 'marketing=(denied|0)', 'granted$', 'no_opt_out'],
      ['equals', undefined, 'optout', undefined, 'unknown']
    ].forEach((c) => {
      const result = run({ cookies: { my_consent: c[1] } }, {
        enableCmp: true,
        cmpPreset: 'custom',
        cmpCustomCookieName: 'my_consent',
        cmpCustomMatchType: c[0],
        cmpCustomOptOutValue: c[2],
        cmpCustomOptInValue: c[3]
      });
      assertThat([result.signals.cmp, result.details.cmp.cookie_found]).isEqualTo([c[4], c[1] !== undefined]);
    });
    assertThat(run({}, { enableCmp: true, cmpPreset: 'custom' }).details.cmp).isEqualTo({ status: 'unknown', preset: 'custom', cookie_found: false });
- name: '[Google Consent Mode] Reads consent_state, x-ga-gcd, x-ga-gcs, npa and rdp'
  code: |-
    [
      [{ consent_state: { ad_storage: false, ad_user_data: true } }, 'opt_out', 'consent_state'],
      [{ consent_state: { ad_storage: true, ad_user_data: false } }, 'opt_out', 'consent_state'],
      [{ consent_state: { ad_storage: true, ad_personalization: false } }, 'opt_out', 'consent_state'],
      [{ consent_state: { ad_storage: true }, 'x-ga-gcd': gcd.denied }, 'no_opt_out', 'consent_state'],
      [{ consent_state: { analytics_storage: true }, 'x-ga-gcd': gcd.denied }, 'opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.granted, 'x-ga-gcs': 'G100' }, 'no_opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.denied }, 'opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.adPersDenied }, 'opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.userDataDenied }, 'opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.grantedUpdate }, 'no_opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.delegated }, 'opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.delegatedToAnalytics }, 'opt_out', 'x-ga-gcd'],
      [{ 'x-ga-gcd': gcd.cycle }, 'unknown', undefined],
      [{ 'x-ga-gcd': gcd.none, 'x-ga-gcs': 'G100' }, 'opt_out', 'x-ga-gcs'],
      [{ 'x-ga-gcd': 'not a gcd', 'x-ga-gcs': 'G111' }, 'no_opt_out', 'x-ga-gcs'],
      [{ 'x-ga-gcd': '13p3p', 'x-ga-gcs': 'G111' }, 'no_opt_out', 'x-ga-gcs'],
      [{ 'x-ga-gcs': 'G100' }, 'opt_out', 'x-ga-gcs'],
      [{ 'x-ga-gcs': 'G1--' }, 'unknown', undefined],
      [{ 'x-ga-gcs': 'G111', 'x-ga-npa': '1' }, 'no_opt_out', 'x-ga-gcs'],
      [{ 'x-ga-gcs': 'G111', 'x-ga-npa': '1' }, 'opt_out', 'x-ga-npa', true],
      [{ 'x-ga-npa': '0' }, 'unknown', undefined, true],
      [{ 'x-sst-system_properties': { rdp: true } }, 'opt_out', 'x-sst-system_properties.rdp', false, true],
      [{ 'x-sst-system_properties': { rdp: false } }, 'unknown', undefined, false, true]
    ].forEach((c) => {
      const result = run(ev(c[0]), { enableConsentMode: true, consentModeReports: 'all', consentModeUseNpa: c[3], consentModeUseRdp: c[4] });
      assertThat([result.signals.consent_mode, result.details.consent_mode.source]).isEqualTo([c[1], c[2]]);
    });

    assertThat(run(ev({ 'x-ga-gcd': gcd.adPersDenied }), { enableConsentMode: true }).details.consent_mode).isEqualTo({
      status: 'opt_out',
      source: 'x-ga-gcd',
      states: { ad_storage: 'granted', ad_user_data: 'granted', ad_personalization: 'denied' },
      value: gcd.adPersDenied
    });
    [
      [gcd.delegated, { ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'granted' }],
      [gcd.delegatedToAnalytics, { ad_storage: 'granted', ad_user_data: 'denied', ad_personalization: 'granted' }],
      [gcd.cycle, undefined]
    ].forEach((c) => {
      assertThat(run(ev({ 'x-ga-gcd': c[0] }), { enableConsentMode: true, consentModeReports: 'all' }).details.consent_mode.states).isEqualTo(c[1]);
    });
- name: '[Google Consent Mode] Opt-out only reports granted as unknown'
  code: |-
    [
      [{ consent_state: { ad_storage: true } }, 'optOutOnly', 'unknown', true],
      [{ 'x-ga-gcd': gcd.granted }, 'optOutOnly', 'unknown', true],
      [{ 'x-ga-gcs': 'G111' }, undefined, 'unknown', true],
      [{ 'x-ga-gcd': gcd.denied }, 'optOutOnly', 'opt_out', undefined],
      [{ 'x-ga-gcd': gcd.granted }, 'all', 'no_opt_out', undefined]
    ].forEach((c) => {
      const result = run(ev(c[0]), { enableConsentMode: true, consentModeReports: c[1] });
      assertThat([result.signals.consent_mode, result.details.consent_mode.granted_reported_as_unknown]).isEqualTo([c[2], c[3]]);
    });

    [['optOutOnly', 'limited', 'no_clear_signal'], ['all', 'allow', 'no_opt_out_signal']].forEach((c) => {
      const result = run(ev({ 'x-ga-gcd': gcd.granted }), { enableConsentMode: true, consentModeReports: c[0], noSignalBehavior: 'optOut' });
      assertThat([result.decision, result.reason]).isEqualTo([c[1], c[2]]);
    });
- name: '[Resolution] Any opt-out wins, priority mode, priority table and fail closed'
  code: |-
    const otOut = { headers: { 'sec-gpc': '1' }, cookies: { OptanonConsent: 'groups=C0004:0' }, eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YNN' } }) };
    const ot = { enableCmp: true, cmpPreset: 'onetrust' };
    assertThat(run(otOut, ot).reason).isEqualTo('gpc');
    assertThat(run(otOut, assign({ signalPriority: [{ signal: 'us_privacy' }, { signal: 'cmp' }, { signal: 'gpc' }] }, ot)).reason).isEqualTo('cmp');

    const otIn = { headers: { 'sec-gpc': '1' }, cookies: { OptanonConsent: 'groups=C0004:1' } };
    let result = run(otIn, assign({ resolutionMode: 'priority', signalPriority: [{ signal: 'cmp' }, { signal: 'gpc' }] }, ot));
    assertThat([result.decision, result.opted_out, result.reason]).isEqualTo(['allow', false, 'cmp']);
    assertThat(run(otIn, assign({ resolutionMode: 'priority' }, ot)).reason).isEqualTo('gpc');
    result = run({ cookies: { OptanonConsent: 'groups=C0002:1' } }, assign({ resolutionMode: 'priority' }, ot));
    assertThat([result.decision, result.reason]).isEqualTo(['allow', 'no_opt_out_signal']);

    const uspOut = { headers: { 'sec-gpc': '1' }, eventData: usEventData({ 'x-sst-system_properties': { us_privacy: '1YYN' } }) };
    assertThat(run(uspOut, { signalPriority: [{ signal: 'bogus' }, {}, { signal: 'us_privacy' }, { signal: 'us_privacy' }] }).reason).isEqualTo('us_privacy');
    assertThat(run(uspOut, { signalPriority: 'not a table' }).reason).isEqualTo('gpc');

    const failClosed = { noSignalBehavior: 'optOut' };
    [
      [{}, {}, 'allow', 'no_opt_out_signal', false],
      [{}, failClosed, 'limited', 'no_clear_signal', true],
      [gpp('garbage!'), { noSignalBehavior: 'optOut', optOutAction: 'block' }, 'block', 'no_clear_signal', true],
      [ev({ 'x-sst-system_properties': { us_privacy: '1YNN' } }), failClosed, 'allow', 'no_opt_out_signal', false],
      [{ cookies: { OptanonConsent: 'groups=C0004:1' } }, assign({ noSignalBehavior: 'optOut', resolutionMode: 'priority' }, ot), 'allow', 'cmp', false],
      [gpcHeader, failClosed, 'limited', 'gpc', true],
      [{ eventData: { event_location: { country: 'BR', region: 'SP' } } }, failClosed, 'allow', 'region_not_applicable', true]
    ].forEach((c) => {
      result = run(c[0], c[1]);
      assertThat([result.decision, result.reason, result.opted_out]).isEqualTo([c[2], c[3], c[4]]);
    });
- name: '[Region] Scope, selected states and unknown location'
  code: |-
    let result = run(at('BR', 'SP'));
    assertThat([result.decision, result.opted_out, result.applies, result.reason, result.country, result.region]).isEqualTo(['allow', true, false, 'region_not_applicable', 'BR', 'SP']);
    assertThat(result.vendor.meta.data_processing_options).isEqualTo([]);
    result = run(at('BR', 'SP'), { regionScope: 'everywhere' });
    assertThat([result.decision, result.applies]).isEqualTo(['limited', true]);

    [
      [{ country: 'US', region: 'CA' }, 'states', undefined, 'apply', true],
      [{ country: 'US', region: 'NY' }, 'states', undefined, 'apply', false],
      [{ country: 'US', region: 'NY' }, 'states', 'ny, nj', 'apply', true],
      [{ country: 'US' }, 'states', undefined, 'apply', true],
      [{ country: 'US' }, 'states', undefined, 'skip', false],
      [undefined, 'us', undefined, 'apply', true],
      [undefined, 'us', undefined, 'skip', false],
      [{ country: 'CA', region: 'QC' }, 'states', undefined, 'apply', false]
    ].forEach((c) => {
      const overrides = { regionScope: c[1], unknownGeoBehavior: c[3] };
      if (c[2]) overrides.regionStates = c[2];
      result = run({ headers: { 'sec-gpc': '1' }, eventData: { event_location: c[0] } }, overrides);
      assertThat([result.applies, result.decision]).isEqualTo([c[4], c[4] ? 'limited' : 'allow']);
    });
- name: '[Geo] Reads event_location, then geo headers, custom variables, and normalizes values'
  code: |-
    [
      [{ event_location: { country: 'us', region: 'ca' } }, { 'x-geo-country': 'BR' }, ['US', 'CA', 'event_location']],
      [{ event_location: { country: 'US' } }, {}, ['US', undefined, 'event_location']],
      [{ event_location: { country: 'XX' } }, { 'x-geo-country': 'US', 'x-geo-region': 'California' }, ['US', 'CA', 'x-geo']],
      [{}, { 'x-geo-country': 'US', 'x-geo-region': 'New York' }, ['US', 'NY', 'x-geo']],
      [{}, { 'x-geo-country': 'ZZ', 'x-gclb-country': 'US', 'x-gclb-region': 'USTX' }, ['US', 'TX', 'x-gclb']],
      [{}, { 'x-geo-country': 'DE', 'x-geo-region': 'Bavaria' }, ['DE', 'BAVARIA', 'x-geo']],
      [{}, { 'x-gclb-country': 'US', 'x-gclb-region': 'USNY', 'cloudfront-viewer-country': 'US' }, ['US', 'NY', 'x-gclb']],
      [{}, { 'cloudfront-viewer-country': 'US', 'cloudfront-viewer-country-region': 'WA' }, ['US', 'WA', 'cloudfront']],
      [{}, { 'x-appengine-country': 'US', 'x-appengine-region': 'ca' }, ['US', 'CA', 'appengine']],
      [{}, { 'x-azure-country': 'us', 'cf-ipcountry': 'BR' }, ['US', undefined, 'azure']],
      [{}, { 'cf-ipcountry': 'US' }, ['US', undefined, 'cf']],
      [{}, { 'cf-ipcountry': 'USA' }, [undefined, undefined, 'none']]
    ].forEach((c) => {
      const result = run({ eventData: c[0], headers: c[1] });
      assertThat([result.country, result.region, result.geo_source]).isEqualTo(c[2]);
    });

    [['us', 'US-TX', 'US', 'TX'], ['US', 'texas', 'US', 'TX'], ['', 'CA', undefined, 'CA']].forEach((c) => {
      const result = run({ eventData: { event_location: { country: 'BR', region: 'SP' } } }, { geoSource: 'custom', customCountry: c[0], customRegion: c[1] });
      assertThat([result.country, result.region, result.geo_source]).isEqualTo([c[2], c[3], 'custom']);
    });
- name: '[Return Types] Each return type returns the matching value'
  code: |-
    [
      ['decision', 'limited', 'allow'],
      ['restricted', true, false],
      ['metaDpo', ['LDU'], []],
      ['metaDpoCountry', 0, undefined],
      ['metaDpoState', 0, undefined],
      ['googleAdsRdp', true, false],
      ['tiktokLdu', true, false]
    ].forEach((c) => {
      assertThat(run(gpcHeader, { returnType: c[0] })).isEqualTo(c[1]);
      assertThat(run({}, { returnType: c[0] })).isEqualTo(c[2]);
    });
    assertThat(run(gpcHeader, { returnType: 'decision', optOutAction: 'block' })).isEqualTo('block');
    assertThat(run(gpcHeader, { optOutAction: 'block' }).vendor.tiktok.limited_data_use).isTrue();
- name: '[Meta] United States mode sets country 1 and the Meta state code'
  code: |-
    [
      ['CA', 1000], ['CO', 1001], ['CT', 1002], ['FL', 1003], ['OR', 1004], ['TX', 1005], ['MT', 1006],
      ['DE', 1007], ['NE', 1008], ['NH', 1009], ['NJ', 1010], ['MN', 1011], ['MD', 1012], ['RI', 1013],
      ['VA', 0], [undefined, 0]
    ].forEach((c) => {
      const meta = run(at('US', c[0]), { metaDpoMode: 'us' }).vendor.meta;
      assertThat([meta.data_processing_options, meta.data_processing_options_country, meta.data_processing_options_state]).isEqualTo([['LDU'], 1, c[1]]);
    });
    assertThat(run(at('IT', 'CO'), { metaDpoMode: 'us', regionScope: 'everywhere' }).vendor.meta.data_processing_options_state).isEqualTo(0);
    const geolocated = run(at('US', 'TX')).vendor.meta;
    assertThat([geolocated.data_processing_options_country, geolocated.data_processing_options_state]).isEqualTo([0, 0]);
setup: |-
  const Object = require('Object');

  const fx = {
    natSale: 'DBABL~BEAaAAAAAAA',
    natNo: 'DBABL~BAAqAAAAAAA',
    natTargeted: 'DBABL~CAApAAAAAAA',
    natGpc: 'DBABL~BAAqAAAAAAA.Y',
    natGpcFalse: 'DBABL~BAAqAAAAAAA.Q',
    natNa: 'DBABL~BAAAAAAAAAA',
    natV3: 'DBABL~DAAQAAAAAAA',
    multi: 'DBADMNg~CPXxRfAPXxRfAAfKABENB-CgAAAAAAAAAAYgAAAAAAAA~BAAqAAAAAAA~BAYAAAAA',
    ranges: 'DBABrY~BAAqAAAAAAA~BAoAAAAA~BAYAAAA',
    iabNatGpc: 'DBABLA~CEAqAAAAAABA.YA',
    iabCaSale: 'DBABBg~BAYAAABA.QA',
    iabMultiNo: 'DBACzzA~1YNN~CAAqAAAAAABA.QA~BAoAABA'
  };

  const gcd = {
    none: '13l3l3l3l1l1',
    granted: '13t3t3t3t500',
    denied: '13p3p3p3p500',
    adPersDenied: '13t3t3t1u500',
    userDataDenied: '13t3t1p3t500',
    grantedUpdate: '11r1r1r1r500',
    delegated: '11p3tNl3t500',
    delegatedToAnalytics: '11t1pRl1t500',
    cycle: '1Vl1tNl1t500',
    gpc: '13t3t3t3td00',
    gpcOnly: '13l3l3l3l900'
  };

  const assign = (target, source) => {
    Object.keys(source || {}).forEach((key) => {
      target[key] = source[key];
    });
    return target;
  };

  const createMockData = (overrides) => {
    return assign(
      {
        returnType: 'object',
        optOutAction: 'limited',
        resolutionMode: 'anyOptOut',
        noSignalBehavior: 'allow',
        enableGpc: true,
        enableGpp: true,
        enableUsPrivacy: true,
        enableCmp: false,
        enableConsentMode: false,
        consentModeReports: 'optOutOnly',
        regionScope: 'us',
        regionStates: 'CA,CO,CT,DE,FL,IA,IN,KY,MD,MN,MT,NE,NH,NJ,OR,RI,TN,TX,UT,VA',
        unknownGeoBehavior: 'apply',
        geoSource: 'auto',
        metaDpoMode: 'geolocation'
      },
      overrides
    );
  };

  const usEventData = (extra) => {
    return assign({ event_name: 'page_view', event_location: { country: 'US', region: 'CA' } }, extra);
  };

  const setRequest = (request) => {
    const eventData = request.eventData === undefined ? usEventData({}) : request.eventData;
    const headers = request.headers || {};
    const cookies = request.cookies || {};
    mock('getAllEventData', () => eventData);
    mock('getRequestHeader', (name) => headers[name.toLowerCase()]);
    mock('getCookieValues', (name) => (cookies[name] === undefined ? [] : [cookies[name]]));
  };

  const run = (request, overrides) => {
    setRequest(request || {});
    return runCode(createMockData(overrides || {}));
  };
  const ev = (extra) => ({ eventData: usEventData(extra) });
  const gpp = (value, sid) => ev({ 'x-sst-system_properties': { gpp: value, gpp_sid: sid } });
  const gpcHeader = { headers: { 'sec-gpc': '1' } };
  const at = (country, region) => ({ headers: { 'sec-gpc': '1' }, eventData: { event_location: { country: country, region: region } } });

  setRequest({});


___NOTES___

2026-11-17 - Change Notes:
  - First release

Created on 11/17/2026, 17:02:22


